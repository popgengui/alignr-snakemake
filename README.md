# alignr-snakemake

- alignr-snakemake is a snakemake workflow that automates processing fastq files. Just underway, the project's workflow currently only trims (with fastp) and aligns (with bwa). Please use this workflow with caution as we have only just started running and testing it. We anticipate soon adding genotyping, to produce vcf files. Currently, our aim is to use the alignR R package to run the programs in each step. 

### System Requirements

- The conda environment created by the workflow uses about 4.2 G of storage.

### Dependencies:

- The Conda and/or Mamba package manager. If you don't already have it, a compact version, recommended by this developer, is at, 

     https://github.com/conda-forge/miniforge
  
- Snakmake, a python-based workflow manager. With a conda manager installed (see above), you can add a snakemake environment with the command,

      conda create -c conda-forge -c bioconda -c nodefaults -n snakemake snakemake	

### Installation and Usage
- Demonstration: after cloning this repository (or downloading and uzipping its archive), and navigating in your terminal to the main repository directory, you can execute the workflow on the demo fastq files in the "demo-input" directory. You first load your snakemake environment, then start the workflow, with the commands:


        conda activate snakemake

        snakemake --cores 1 --use-conda

     Note that you can set the number of cores depending on the number available on your machine, and at your discretion.
     
     On the first run of the workflow, it will download and install aconda envirnoment that includes an R installation and multiple programs needed by the alignR package. This can take just a few or over 10 minutes, depending on your internet connection speed. It will also install the alignR package. Once the conda environment is present, subsequent executions of the workflow will skip these downloads and installations.

- Running with your own fastq files

    - Add two files to the directory containing your fastq files. One file will list the fastqs that hold the first (R1) of the paired reads, the second should list, in the same order, their corresponding seconds (R2). You can see an example of these inside the "demo-input" directory, named "read_one_fastqs.csv", and "read_two_fastqs.csv". You can copy these into your own data's directory and replace their contents with the names of your fastq pairs. You can trim and align unpaired fastqs by listing them in the read\_one list, and leaving the read\_two list empty.

    - In the file config/config.yaml, assign the "data_dir" entry the path to your data directory, either full or relative to the alignr-snakemake directory.  Assign the fastq-file-list file names you've added to your  data directory.  Using the names of the latter, you also need to assign two trimmed-file-list file names.  These will be created automatically after the trimming, and will be named identically to those that give the raw fastq file lists, but with the extension ".trimmed" appended. 

    - For the alignment, you will need to have a reference sequence (it can be gzipped) in the directory with your fastq files. Its name should be assigned in the config/config.yaml file where indicated.
  
    - You should also see the config/alignr_config.yaml file, where you can set parameters for the processes, such as adapter sequences for the fastp trimming, 
