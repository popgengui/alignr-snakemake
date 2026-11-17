# alignr-snakemake

- alignr-snakemake is a snakemake workflow that automates processing fastq files.  Just underway, the project's workflow currently trims (with fastp) and aligns (with bwa).   Please use this workflow with caution as we have only just started running and testing it.  We anticipate soon adding a genotyping step, to produce vcf files.  The alignR R package facilitates the steps, and uses fastp for trimming, bwa for aligning, and, when implemented, angsd for genotyping.  

### Dependencies:

- The Conda and/or Mamba package manager.  If you don't already have it, a compact version, recommended by this developer, is at, 

     https://github.com/conda-forge/miniforge
  
- Snakmake, a python-based workflow manager.  With a conda manager (see above) installed, you can add a snakemake environment with the command,

      `conda create -c conda-forge -c bioconda -c nodefaults -n snakemake snakemake`	

### Installation and Usage
- Demonstration:  after cloning this repository, and with your terminal, you can execute the workflow on the demo fastq files in the "demo-input" directory inside the repository main directory.  You first load your snakemake environment, then start the workflow,  with the commands:


        `conda activate snakemake`

        `snakemake --cores 1 --use-conda`

     Note that you can set the number of cores depending on the number available on your machine, and at your discretion.

     
     On the first run of the workflow, it will download and install an R environment, adding multiple programs needed by the alignR package.   This can take just a few or over 10 minutes, depending on your internet connection.  It will also install the alignR package.  Once the conda environment is present, the workflow will skip these downloads and installations.

- Running with your own fastq files

    - Add two files to the directory containing your fastq files.  One file will list the fastqs that hold the first (R1) of the paired reads, the second should list, in the same order, their corresponding seconds (R2).  You can see an example of these inside the "demo-input" directory, named "read_one_fastqs.csv", and "read_two_fastqs.csv".  You can copy these into your own data's directory and replace their contents with the names of your fastq pairs. You can trim and align only one set of fastqs without pairs, by listing the fastqs in the read\_one list, and leaving the read\_two list empty.

    - In the file config/config.yaml, replace the existing paths and list-file names (created for the demo-input)  for those that you've made in your data directory.  Note that you should enter the name of the trimmed file lists, which will be created automatically after the trimming, as identical to the first lists, with the extension ".trimmed" added. 

    - For the alignment, you will need to have a reference sequence (it can be gzipped), and its path and name should be assigned in the config/config.yaml file where indicated.
  
    - You should also see the config/alignr_config.yaml file, where you can set parameters for the processes, such as adapter sequences for the fastp trimming, 
