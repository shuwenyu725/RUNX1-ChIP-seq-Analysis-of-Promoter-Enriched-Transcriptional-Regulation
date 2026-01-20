#!/usr/bin/env nextflow

process BAMCOVERAGE {

  label 'process_medium'
  container 'ghcr.io/bf528/deeptools:latest'
  publishDir "${params.outdir}/bigwig", mode: 'copy'

  input:
  tuple val(sample), path(sorted_bam), path(sorted_bai)

  output:
  tuple val(sample), path("${sample}.bw"), emit: bw

  script:
  """
  bamCoverage -b $sorted_bam -o ${sample}.bw -p ${task.cpus}
  """

  stub:
  """
  touch ${sample}.bw
  """

}