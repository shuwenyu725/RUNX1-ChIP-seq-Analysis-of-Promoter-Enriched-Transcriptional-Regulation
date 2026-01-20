#!/usr/bin/env nextflow

process MULTIBWSUMMARY {

    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir "${params.outdir}/correlation", mode: 'copy', pattern: '*'

    input:
    path bigwigs  

    output:
    path "bw_all.npz", emit: npz
    path "bw_all.tab", emit: tab

    script:
    """
    multiBigwigSummary bins \
        -b ${bigwigs.join(' ')} \
        -o bw_all.npz \
        --outRawCounts bw_all.tab \
        -p ${task.cpus}
    """

    stub:
    """
    touch bw_all.npz
    touch bw_all.tab
    """

}

