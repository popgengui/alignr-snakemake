from pathlib import Path

rule run_align_reference:
	input: 
		f"{workflow.basedir}/envs/alignr-env.yaml",
		kernel_set="results/.kernel.set",	
		fastq_r1_list = Path( config['data_dir'] ) / config['list_trimmed_r1_fastqs'],
		fastq_r2_list = Path( config['data_dir'] ) / config['list_trimmed_r2_fastqs'],
		refseq = Path( config['data_dir']  ) / config[ 'reference_sequences' ] ,
		rsutils = "scripts/rs_utils.R"
	output:
		touch( "results/.alignment_done" ),
	conda:
		"../envs/alignr-env.yaml",
	log:
		"logs/alignr.align.log"
		
	params:
		args = config["align_reference"]
	script:
		"../scripts/run_align_reference.R"

#end rule run_trim_fastp

	
