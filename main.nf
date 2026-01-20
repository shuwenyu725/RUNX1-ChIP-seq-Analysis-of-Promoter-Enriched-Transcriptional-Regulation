#!/usr/bin/env nextflow

include { FASTQC }        from './modules/fastqc'
include { TRIM }          from './modules/trimmomatic'
include { BOWTIE2_BUILD } from './modules/bowtie2_build'
include { BOWTIE2_ALIGN } from './modules/bowtie2_align'
include { SAMTOOLS_SORT    } from './modules/samtools_sort'
include { SAMTOOLS_IDX  } from './modules/samtools_idx'
include { SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include { BAMCOVERAGE } from './modules/deeptools_bamcoverage'
include { MULTIQC          } from './modules/multiqc'
include { MULTIBWSUMMARY } from './modules/deeptools_multibwsummary'
include { PLOTCORRELATION } from './modules/deeptools_plotcorrelation'
include { TAGDIR } from './modules/homer_maketagdir'
include { FINDPEAKS } from './modules/homer_findpeaks'
include { POS2BED } from './modules/homer_pos2bed'
include { BEDTOOLS_INTERSECT } from './modules/bedtools_intersect'
include { BEDTOOLS_REMOVE } from './modules/bedtools_remove'
include { ANNOTATE } from './modules/homer_annotatepeaks'
include { COMPUTEMATRIX } from './modules/deeptools_computematrix'
include { PLOTPROFILE }  from './modules/deeptools_plotprofile'
include { FIND_MOTIFS_GENOME }  from './modules/homer_findmotifsgenome'


workflow {
  Channel.fromPath(params.samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.path)) }
    | set { read_ch }

    // Quality control on raw reads
    FASTQC(read_ch)

    // Trim adapters and low-quality reads
    TRIM(read_ch)

    // Build Bowtie2 index from reference genome
    BOWTIE2_BUILD(file(params.genome))

    // Align trimmed reads to genome
    BOWTIE2_ALIGN(TRIM.out.reads, BOWTIE2_BUILD.out.idx)

    // Sort & index BAM
    SAMTOOLS_SORT(BOWTIE2_ALIGN.out.bam)
    SAMTOOLS_IDX(SAMTOOLS_SORT.out.sorted)

    // Flagstat on sorted BAM
    SAMTOOLS_FLAGSTAT(SAMTOOLS_SORT.out.sorted)

    BAMCOVERAGE(SAMTOOLS_SORT.out.sorted.join( SAMTOOLS_IDX.out.bai ))
    
    FASTQC.out.zip.map{ it[1] }
    .mix(TRIM.out.trimlog.map{ it[1] })
    .mix(SAMTOOLS_FLAGSTAT.out.flagstat.map{ it[1] })
    .collect()
    .set{ multiqc_files }
    MULTIQC(multiqc_files)


    BAMCOVERAGE.out.bw
    .map { sample, bw -> bw }
    .collect()
    .set { all_bw }

    MULTIBWSUMMARY(all_bw)
    PLOTCORRELATION(MULTIBWSUMMARY.out.npz)

    TAGDIR( BOWTIE2_ALIGN.out.bam )

    def tagdirs = TAGDIR.out

    def repFrom = { String name ->
        def m = (name =~ /_(rep\d+)/)   
        assert m.find() : "Cannot extract replicate from sample name: ${name}"
        m.group(1)                       
    }

    ip_tagdirs = tagdirs
        .filter { sample, tagdir -> sample.toUpperCase().startsWith('IP_') }
        .map    { sample, tagdir -> tuple( repFrom(sample.toString()), tagdir ) }       

    ctrl_tagdirs = tagdirs
        .filter { sample, tagdir -> sample.toUpperCase().startsWith('INPUT_') }
        .map    { sample, tagdir -> tuple( repFrom(sample.toString()), tagdir ) }       

    paired_tagdirs = ip_tagdirs.join(ctrl_tagdirs)  

    // Pass to FINDPEAKS 
    FINDPEAKS(paired_tagdirs)


    POS2BED(FINDPEAKS.out)

        
    rep1_bed = POS2BED.out.bed
        .filter { rep, bed -> rep == 'rep1' }     
        .map    { rep, bed -> bed }               

    rep2_bed = POS2BED.out.bed
        .filter { rep, bed -> rep == 'rep2' }     
        .map    { rep, bed -> bed }               


    rep1_tagged = rep1_bed.map { bed_path -> tuple('pair', bed_path) }
    rep2_tagged = rep2_bed.map { bed_path -> tuple('pair', bed_path) }


    joined_beds = rep1_tagged.join(rep2_tagged)

    two_beds = joined_beds.map { key, bed1, bed2 -> tuple(bed1, bed2) }

    BEDTOOLS_INTERSECT(two_beds)

    BEDTOOLS_REMOVE(BEDTOOLS_INTERSECT.out.repr,file(params.blacklist))

    ANNOTATE(BEDTOOLS_REMOVE.out,
        file(params.genome),
        file(params.gtf))

    ip_bw_ch = BAMCOVERAGE.out.bw
    .filter { sample, bw -> sample.toString().toUpperCase().startsWith('IP_') }
    .map    { sample, bw -> tuple(sample.toString(), bw) }

    bed_ch    = Channel.value( file(params.ucsc_genes) )   
    window_ch = Channel.value( params.window )             

    COMPUTEMATRIX(
    ip_bw_ch,         
    bed_ch,            
    window_ch         
    )

    PLOTPROFILE( COMPUTEMATRIX.out.matrix )
    
    

    FIND_MOTIFS_GENOME(
    BEDTOOLS_REMOVE.out, file(params.genome))
   
}



