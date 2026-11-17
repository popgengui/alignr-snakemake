
from pathlib import Path

rule run_trim_fastp:
	input: 
		f"{workflow.basedir}/envs/alignr-env.yaml",
		kernel_set="results/.kernel.set",	
		fastq_r1_list = Path( config['data_dir'] ) / config['list_r1_fastqs'],
		fastq_r2_list = Path( config['data_dir'] ) / config['list_r2_fastqs'],
		rsutils = "scr/rs_utils.R"
	output:
		Path( config['data_dir'] ) / f"{config[ 'list_r1_fastqs' ]}.trimmed",
		Path( config['data_dir'] ) / f"{config[ 'list_r2_fastqs' ]}.trimmed"
	conda:
		"../envs/alignr-env.yaml"
	log:
		"logs/alignr.trim.log"
		
	params:
		args = config["trim_fastp"]
	script:
		"../scr/run_trim_fastp.R"

#end rule run_trim_reference

		
