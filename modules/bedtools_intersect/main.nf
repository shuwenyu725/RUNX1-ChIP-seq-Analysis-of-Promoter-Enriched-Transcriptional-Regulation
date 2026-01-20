#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    
    label 'process_single'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir "${params.outdir}/bed", mode: 'copy'

    input:
    tuple path(rep1_bed), path(rep2_bed)

    output:
    path "repr_peaks.bed", emit: repr


    script:
    """
    bedtools intersect -a ${rep1_bed} -b ${rep2_bed} > repr_peaks.bed
    """

    stub:
    """
    touch repr_peaks.bed
    """
}