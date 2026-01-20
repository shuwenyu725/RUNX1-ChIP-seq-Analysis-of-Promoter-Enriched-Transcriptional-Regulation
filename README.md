ChIP-seq Analysis Pipeline – RUNX1 

Overview<br>
This repository contains a reproducible ChIP-seq analysis pipeline implemented in Nextflow DSL2 to process transcription factor ChIP-seq data and identify high-confidence binding sites.
The pipeline was used to reproduce key ChIP-seq findings from a published RUNX1 breast cancer study, including peak calling, replicate concordance assessment, motif enrichment, and integration with external RNA-seq results.

Biological Context
RUNX1 is a transcription factor involved in gene regulation and chromatin organization and has context-dependent roles in breast cancer.
This project focuses on reconstructing RUNX1 binding profiles and evaluating their reproducibility and functional relevance using ChIP-seq data.

What This Pipeline Does
- Performs quality control and preprocessing of raw FASTQ files
- Aligns reads to the human reference genome
- Calls transcription factor binding peaks with matched input controls
- Identifies reproducible peaks across biological replicates
- Annotates peaks and performs motif enrichment analysis
- Generates genome-wide signal tracks and correlation plots
- Integrates ChIP-seq results with published RNA-seq differential expression data

Workflow Summary
QC → Trimming → Alignment → Peak Calling → Replicate Filtering → Annotation → Motif Analysis → Integration

Tools & Technologies
- Workflow: Nextflow (DSL2)
- Containers: Singularity
- QC: FastQC, MultiQC
- Trimming: Trimmomatic
- Alignment: Bowtie2, SAMtools
- Peak calling & annotation: HOMER
- Signal processing: deepTools
- Utilities: BEDTools
- Downstream analysis: Enrichr 

All tools are executed using containerized environments to ensure reproducibility.

Repository Structure
.
├── main.nf               # Main workflow
├── nextflow.config       # Execution configuration
├── modules/              # Modular DSL2 processes
├── refs/                 # Reference genome and annotations
├── results/              # Output files (peaks, QC, plots)
└── README.md

Running the Pipeline
nextflow run main.nf \
  -profile singularity,local \
  --genome refs/GRCh38.fa \
  --reads "data/*.fastq.gz"

Stub runs were used during development to validate pipeline logic before full execution.

Results Summary<br>
ChIP-seq data showed high alignment quality and strong replicate concordance
RUNX1 binding was enriched near transcription start sites
Motif analysis identified RUNX-family motifs, along with known co-regulatory factors
Integration with RNA-seq data reproduced key trends reported in the original study, despite differences in genome build and processing parameters

Key Takeaways<br>
Built a modular, reproducible ChIP-seq pipeline using Nextflow DSL2
Applied method-aware peak filtering to improve biological interpretability
Learned to reproduce published results conceptually, not just visually
Gained experience explaining why results differ while conclusions agree
Strengthened ability to communicate epigenomic results to non-specialists

Limitations<br>
Hi-C analyses from the original study were not reproduced
Genome build (hg38) and processing parameters differ from the publication (hg19)
RNA-seq integration relied on published DEG tables rather than reprocessing raw data

Course Context<br>
Developed for BF 528 Boston University, Fall 2025

Author
Shu-Wen Yu
M.S. Bioinformatics | Nutrition background
Interests: epigenomics, reproducible workflows, integrative omics analysis

