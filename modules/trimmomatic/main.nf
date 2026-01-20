#!/usr/bin/env nextflow

process TRIM {

    label 'process_medium'
    container 'ghcr.io/bf528/trimmomatic:latest'
    publishDir "${params.outdir}/trimmed", mode: 'copy'


    input:
    tuple val(sample), path(fastq)

    output:
    tuple val(sample), path("${sample}_trimmed.fq.gz"), emit: reads
    tuple val(sample), path("${sample}_trimmomatic.log"), emit: trimlog

    script:
    """
    trimmomatic SE -threads $task.cpus -phred33 \
      $fastq ${sample}_trimmed.fq.gz \
      ILLUMINACLIP:${params.adapter_fa}:2:30:10 \
      LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 \
      2> ${sample}_trimmomatic.log
    """
    stub:
    """
    touch ${sample}_trimmed.fq.gz
    touch ${sample}_trimmomatic.log
    """
}
