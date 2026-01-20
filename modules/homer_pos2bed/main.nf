#!/usr/bin/env nextflow

process POS2BED {

    label 'process_single'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/bed", mode: 'copy'

    input:
    tuple val(sample), path(homer_txt)

    output:
    tuple val(sample), path("${homer_txt.baseName}.bed"), emit: bed

    script:
    """
    pos2bed.pl ${homer_txt} > ${homer_txt.baseName}.bed
    """

    stub:
    """
    touch ${homer_txt.baseName}.bed
    """
}


