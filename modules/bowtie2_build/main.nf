#!/usr/bin/env nextflow

process BOWTIE2_BUILD {

  label 'process_high'
  container 'ghcr.io/bf528/bowtie2:latest'
  publishDir "${params.refdir}", mode: 'copy'

  input: path consensus

  output:
 
  path "bowtie2_index/genome.*.bt2", emit: idx

  script:
  """
  mkdir -p bowtie2_index
  bowtie2-build $consensus bowtie2_index/genome
  """

  stub:
  """
  mkdir -p bowtie2_index
  touch bowtie2_index/genome.1.bt2 \
        bowtie2_index/genome.2.bt2 \
        bowtie2_index/genome.3.bt2 \
        bowtie2_index/genome.4.bt2 \
        bowtie2_index/genome.rev.1.bt2 \
        bowtie2_index/genome.rev.2.bt2
  """
}