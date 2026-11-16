rule run_align_reference:
	input: 
		f"{workflow.basedir}/envs/alignr-env.yaml",
		kernel_set="results/.kernel.set",	
		fastq_r1_list = config['list_trimmed_r1_fastqs'],
		fastq_r2_list = config['list_trimmed_r2_fastqs'],
		refseq = config[ 'reference_sequences' ] ,
		rsutils = "scr/rs_utils.R"
	output:
		touch( "results/.alignment_done" ),
	conda:
		"../envs/alignr-env.yaml",
	log:
		"logs/alignr.align.log"
		
	params:
		args = config["align_reference"]
	script:
		"../scr/run_align_reference.R"

#end rule run_trim_fastp

	
