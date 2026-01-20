#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {

  label 'process_high'
  container 'ghcr.io/bf528/bowtie2:latest'
  publishDir "${params.outdir}/bam", mode: 'copy'

  input:
  tuple val(sample), path(trimmed_fastq)
  path index_files

  output:
  tuple val(sample), path("${sample}.bam"), emit: bam

  script:
  """
  bowtie2 -x genome -U $trimmed_fastq -S ${sample}.sam --threads $task.cpus
  samtools view -bS ${sample}.sam > ${sample}.bam

  """

  stub:
  """
  touch ${sample}.bam
  """
}

