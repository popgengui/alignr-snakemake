# alignr-snakemake

##- alignr-snakemake is a snakemake workflow that automates processing fastq files to produce genotyped vcf files.  The alignR R package facilitates the steps, and uses fastp for trimming, bwa for aligning, and angsd for genotyping.  

## Dependancies:

### The Conda and/or Mamba package manager.  If you don't already have it, a compact version, recmmended by this developer, is at https://github.com/conda-forge/miniforge
  
### Snakmake, a python-based workflow manager.  With a conda manager (see above) installed, you can add a snakemake environment with the command
####	conda create -c conda-forge -c bioconda -c nodefaults -n snakemake snakemake

