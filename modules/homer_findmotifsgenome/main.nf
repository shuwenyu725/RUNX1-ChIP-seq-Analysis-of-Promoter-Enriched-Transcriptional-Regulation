#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {

label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/findmotifgenome", mode: 'copy'

    input:
    path bed      
    path genome    

    output:
    path "motifs"  
    
    script:
    """
    findMotifsGenome.pl $bed $genome motifs -size 200 -len 8,10,12 -mask -p 4
    """
    
    stub:
    """
    mkdir motifs
    """

}


