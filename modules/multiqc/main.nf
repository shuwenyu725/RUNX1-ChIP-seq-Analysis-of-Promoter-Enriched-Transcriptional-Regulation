#!/usr/bin/env nextflow

process MULTIQC {

    label 'process_single'
    container 'ghcr.io/bf528/multiqc:latest'
    publishDir "${params.outdir}/multiqc", mode: 'copy', pattern: 'multiqc_report.html'

    input:
    path(qc_files)

    output:
    path('multiqc_report.html'), emit: report

    script:
    """
    multiqc . -o .
    """

    stub:
    """
    touch multiqc_report.html
    """
}