
if (!requireNamespace("alignR", quietly = TRUE)) {
	    remotes::install_github("hemstrow/alignR", upgrade = "never")
}#end if require
 
library( alignR )

#provides utilities to read in and validate file lists:
source(file.path(dirname(snakemake@input[["rsutils"]]), "rs_utils.R"))

b.no.read.two.fastqs = FALSE
l.myargs = snakemake@params[["args"]]

s.input.file.list.r1 = snakemake@input[[ 'fastq_r1_list' ]]
s.input.file.list.r2 = snakemake@input[[ 'fastq_r2_list' ]]

v.read.one.fastqs = get.file.vector( s.input.file.list.r1  )
v.read.two.fastqs = get.file.vector( s.input.file.list.r2  )

l.result.of.validation = validate.paired.fastq.file.lists( v.read.one.fastqs, v.read.two.fastqs )

if( l.result.of.validation[["valid"]] == FALSE )
{
	stop( paste( "Error in input file lists:", 
		    l.result.of.validation[["message"]] ) )

}#end if invalid list

if( length( v.read.two.fastqs ) == 0 )
{
	v.read.two.fastqs=NULL
}#end if no read two fastqs

i.num.read.one.fastqs=length( v.read.one.fastqs )

for ( i.n in 1:i.num.read.one.fastqs )
{
	s.read.one.fastq=v.read.one.fastqs[ i.n ]

	s.read.two.fastq=NULL

        if( !(is.null( v.read.two.fastqs) ) )
	{	   
		s.read.two.fastq=v.read.two.fastqs[ i.n ]
	}#end if read two fastq exists

	#20261116.  The cause may be R's lazy fx arg evaluation 
	#(per google): in the case in which there are no read-two fastqs,
	#passing a variable set to NULL, to the RB_fastqs argument,
	#causes bwa to read it as an invalid file name. Hence, 
	#we'll use do_call() which, per google, will solve the issue.

	l.args=list( RA_fastqs = s.read.one.fastq,
			RB_fastqs = s.read.two.fastq,
			reference = snakemake@input[["refseq"]],
			mapQ = l.myargs[["mapQ"]],
			read_metadata = l.myargs[["read_metadata"]],
			remove_duplicates = l.myargs[["remove_duplicates"]],
			remove_improper_pairs=l.myargs[["remove_improper_pairs"]],
			par=l.myargs[["par"]] )

	do.call( align_reference, l.args )

	###### TO DO:
	#code here to infer name of resulting bam file
	#and adding it to a list of bam files, the list
	#file to be input into a run_genotypeing.R script
	#####

}#end for each fastq (pair, if read two's exist)
		      
