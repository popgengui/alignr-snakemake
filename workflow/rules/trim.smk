
from pathlib import Path

path_files_r1 = Path( config['data_dir'] ) / Path( config['list_r1_fastqs'])
path_files_r2 = Path( config['data_dir'] ) / Path( config['list_r2_fastqs'])

path_trim_files_r1 = Path( config['data_dir'] ) /  f"{config[ 'list_r1_fastqs' ]}.trimmed"
path_trim_files_r2 = Path( config['data_dir'] ) /  f"{config[ 'list_r2_fastqs' ]}.trimmed"

rule run_trim_fastp:
	input: 
		condaevn=f"{workflow.basedir}/envs/alignr-env.yaml",
		kernel_set="results/.kernel.set",	
		fastq_r1_list = path_files_r1,
		fastq_r2_list = path_files_r2,
		rsutils=f"{workflow.basedir}/scripts/rs_utils.R"
	output:
		path_trim_files_r1,
		path_trim_files_r2,
		touch( "results/.trimming_done" ),
	conda:
		f"{workflow.basedir}/envs/alignr-env.yaml"
	log:
		"logs/alignr.trim.log"
		
	params:
		args = config["trim_fastp"]
	script:
		"../scripts/run_trim_fastp.R"

#end rule run_trim_reference

		
