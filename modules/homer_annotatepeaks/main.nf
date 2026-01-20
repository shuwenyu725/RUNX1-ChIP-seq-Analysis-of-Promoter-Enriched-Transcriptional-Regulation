#!/usr/bin/env nextflow

process ANNOTATE {

    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/annot", mode: 'copy'

    input:
    path filtered_bed
    path genome_fa
    path gtf_file

    output:
    path "annotated_peaks.txt"

    script:
    """
    annotatePeaks.pl ${filtered_bed} ${genome_fa} -gtf ${gtf_file} > annotated_peaks.txt
    """

    stub:
    """
    touch annotated_peaks.txt
    """
}



