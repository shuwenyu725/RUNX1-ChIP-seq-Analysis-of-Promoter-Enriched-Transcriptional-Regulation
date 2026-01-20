#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {

  label 'process_low' 
  container 'ghcr.io/bf528/samtools:latest'
  publishDir "${params.outdir}/qc", mode: 'copy', pattern: '*.txt'

  input:
  tuple val(sample), path(sorted_bam)

  output:
  tuple val(sample), path("${sample}_flagstat.txt"), emit: flagstat

  script:
  """
  samtools flagstat $sorted_bam > ${sample}_flagstat.txt
  """

    stub:
    """
    touch ${sample}_flagstat.txt
    """
}