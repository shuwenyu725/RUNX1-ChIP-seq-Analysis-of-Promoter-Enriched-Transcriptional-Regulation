#!/usr/bin/env nextflow

process PLOTCORRELATION {

  label 'process_medium'
  container 'ghcr.io/bf528/deeptools:latest'
  publishDir "${params.outdir}/correlation", mode: 'copy', pattern: '*'

  input:
  path npz

  output:
  path "correlation_plot.png", emit: plot
  path "correlation_values.tab", emit: table

  
  script:
  """
  plotCorrelation \
    -in ${npz} \
    -c pearson \
    -p heatmap \
    -o correlation_plot.png \
    --outFileCorMatrix correlation_values.tab  
  """

  

  stub:
  """
  touch correlation_plot.png
  touch correlation_values.tab
  """
}






