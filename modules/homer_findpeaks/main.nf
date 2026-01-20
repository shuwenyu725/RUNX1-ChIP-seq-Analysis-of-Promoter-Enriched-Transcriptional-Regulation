#!/usr/bin/env nextflow

process FINDPEAKS {
  
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/peaks", mode: 'copy'

    input:
    tuple val(rep), path(ip_tagdir), path(ctrl_tagdir)

    output:
    tuple val(rep), path("*txt"), emit:peaks

    script:
    """
    findPeaks ${ip_tagdir} -style factor -o  ${rep}_peaks.txt
    """
    stub:
    """
    touch ${rep}_peaks.txt
    """
}


