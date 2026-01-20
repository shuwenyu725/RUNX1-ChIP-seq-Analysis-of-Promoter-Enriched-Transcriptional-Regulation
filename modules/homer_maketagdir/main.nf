#!/usr/bin/env nextflow

process TAGDIR {

    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/tagdir", mode: 'copy'

    input:
    tuple val(sample), path(bam)

    output:
    tuple val(sample), path("${sample}.tagdir")

    script:
    """
    mkdir ${sample}.tagdir
    makeTagDirectory ${sample}.tagdir ${bam} -tbp 1
    """
    stub:
    """
    mkdir ${sample}.tagdir
    """

}


