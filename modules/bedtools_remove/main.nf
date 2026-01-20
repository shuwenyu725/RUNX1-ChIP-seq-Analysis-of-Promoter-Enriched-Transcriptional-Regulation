#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
   
  label 'process_single'
  container 'ghcr.io/bf528/bedtools:latest'
  publishDir "${params.outdir}/bed", mode: 'copy'

  input:
  path repr_bed            
  path blacklist_bed

  output:
  path "repr_peaks_filtered.bed"

  script:
  """
  bedtools subtract -A -a ${repr_bed} -b ${blacklist_bed} > repr_peaks_filtered.bed
  """
  stub:
  """
  touch repr_peaks_filtered.bed
  """
}