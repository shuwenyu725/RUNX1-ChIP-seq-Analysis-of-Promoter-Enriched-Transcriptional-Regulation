#!/usr/bin/env nextflow

process PLOTPROFILE {
    
label 'process_single'
  container 'ghcr.io/bf528/deeptools:latest'
  publishDir "${params.outdir}/computematrix", mode: 'copy'

  input:
  tuple val(sample), path(matrix_gz)

  output:
  tuple val(sample), path("${sample}_profile.png")

  script:
  """
  plotProfile \
    -m ${matrix_gz} \
    -out ${sample}_profile.png \
    --perGroup --legendLocation upper-right \
    --plotTitle "IP coverage over genes (${sample})"
  """

  stub:
  """
  convert -size 800x400 xc:white ${sample}_profile.png
  """

    stub:
    """
    touch ${sample}_profile.png

    """
}