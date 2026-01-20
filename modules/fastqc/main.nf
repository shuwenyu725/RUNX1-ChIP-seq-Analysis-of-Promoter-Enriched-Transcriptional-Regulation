#!/usr/bin/env nextflow

process FASTQC {

  label 'process_low'
  container 'ghcr.io/bf528/fastqc:latest'
  publishDir "${params.outdir}/fastqc", mode: 'copy', pattern: '*.html'

  input:
  tuple val(sample), path(fastq)

  output:
  tuple val(sample), path("*.zip"),  emit: zip
  tuple val(sample), path("*.html"), emit: html

  script:
  """
  fastqc $fastq --outdir .
  """

  stub:
  """
  touch ${sample}_fastqc.zip
  touch ${sample}_fastqc.html
  """
}