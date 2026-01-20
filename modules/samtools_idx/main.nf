#!/usr/bin/env nextflow

process SAMTOOLS_IDX {


  label 'process_low'
  container 'ghcr.io/bf528/samtools:latest'
  publishDir "${params.outdir}/bam", mode: 'copy'

  input:
  tuple val(sample), path(sorted_bam)

  output:
  tuple val(sample), path("${sample}.sorted.bam.bai"), emit: bai

  script:
  """
  samtools index -@ $task.cpus $sorted_bam
  """

    stub:
    """
    touch ${sample}.sorted.bam.bai
    """
}