#!/usr/bin/env nextflow

process SAMTOOLS_SORT {

  label 'process_medium'
  container 'ghcr.io/bf528/samtools:latest'
  publishDir "${params.outdir}/bam", mode: 'copy'

  input:
  tuple val(sample), path(bam)

  output:
  tuple val(sample), path("${sample}.sorted.bam"), emit: sorted

  script:
  """
  samtools sort -@ $task.cpus -o ${sample}.sorted.bam $bam
  """

    stub:
    """
    touch ${sample}.sorted.bam
    """
}