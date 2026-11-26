
if (!requireNamespace("alignR", quietly = TRUE)) {
	    remotes::install_github("hemstrow/alignR", upgrade = "never")
}#end if require

library( alignR )

#provides utilities to read in and validate file lists:
source(file.path(dirname(snakemake@input[["rsutils"]]), "rs_utils.R"))


##### supporting functions
get.fastp.tagged.result.read.files=function( v.input.read.files )
{
	v.r1.ext=tools::file_ext( v.input.read.files )

	v.r1.ext.with.dot=paste( ".",  v.r1.ext, sep="" )
	#for files with no ext, we want no terminal dot
	v.r1.ext.with.dot[ v.r1.ext.with.dot == "."] = ""
	v.r1.no.ext=tools::file_path_sans_ext( v.input.read.files )

	v.tagged=paste( v.r1.no.ext, 
		       		"_trimmed", 
				v.r1.ext.with.dot, sep="" )
	return( v.tagged )
}#ene get.fastp.tagged.result.read.files

get.vec.result.file.names=function( v.r1.files, v.r2.files )
{

	#All valid fastp runs should result from at
	#least one file listing for read-one files:
	v.r1.trimmed=
		get.fastp.tagged.result.read.files( v.r1.files )

	v.r2.trimmed=NULL
	if( !is.null( v.r2.files) )
	{
 
		v.r2.trimmed=
			get.fastp.tagged.result.read.files( v.r2.files )
	}#dnd if non null read two lst
	  
	return( list( r1=v.r1.trimmed, r2=v.r2.trimmed ) )	
	
}#end get.vec.result.file.names

stop.if.output.file.lists.already.exist=function( s.r1.list, s.r2.list )
{

	b.out.1=file.exists( s.r1.list )
	b.out.2=file.exists( s.r2.list )
	v.err.msgs=c( NULL, NULL )

	if( b.out.1 )
	{
		v.err.msgs[1]="Read one output file list already exists"
	}#end if RA list

	if( b.out.2 )
	{
		v.err.msgs[2]="Read two output file list already exists"
	}#end if RA list

	if ( b.out.1 || b.out.2 )
	{
		s.main.msg = paste( "Error: ", v.err.msgs, sep="" ) 
		stop( s.main.msg )
	}

	return()
}#end stop.if.output.file.lists.already.exist

##### end supporting functions

b.no.read.two.fastqs = FALSE
l.myargs = snakemake@params[["args"]]

s.input.file.list.r1 = snakemake@input[[ 'fastq_r1_list' ]]
s.input.file.list.r2 = snakemake@input[[ 'fastq_r2_list' ]]

s.output.file.list.r1 = paste0( s.input.file.list.r1, ".trimmed" ) 
s.output.file.list.r2 = paste0( s.input.file.list.r2, ".trimmed" ) 


#before running the trimmer, we make sure no retults file already exist:
stop.if.output.file.lists.already.exist( s.output.file.list.r1, s.output.file.list.r2 )

v.read.one.fastqs = get.file.vector( s.input.file.list.r1  )
v.read.two.fastqs = get.file.vector( s.input.file.list.r2  )

l.result.of.validation = 
	validate.paired.fastq.file.lists( v.read.one.fastqs, v.read.two.fastqs )

if( l.result.of.validation[["valid"]] == FALSE )
{
	stop( paste( "Error in input file lists:", 
		    l.result.of.validation[["message"]] ) )

}#end if invalid list

if( length( v.read.two.fastqs ) == 0 )
{
	v.read.two.fastqs=NULL
}#end if no read two fastqs

alignR::trim_fastp( RA_fastqs=v.read.one.fastqs,
		   RB_fastqs=v.read.two.fastqs,
		   adapter_r1=l.myargs[["adapter_r1"]],
		   adapter_r2=l.myargs[["adapter_r2"]],
		   cut_front=l.myargs[["cut_front"]],
		   cut_front_mean_quality=l.myargs[["cut_front_mean_quality"]],
		   cut_tail=l.myargs[["cut_tail"]],
		   cut_tail_mean_quality=l.myargs[["cut_tail_mean_quality"]],
		   cut_right=l.myargs[["cut_right"]],
		   cut_right_mean_quality=l.myargs[["cut_right_mean_quality"]],
		   trim_poly_g=l.myargs[["trim_poly_g"]],
		   trim_poly_x=l.myargs[["trim_poly_y"]],
		   par=l.myargs[["par"]] )


l.result.files=get.vec.result.file.names( v.read.one.fastqs, v.read.two.fastqs )
 
writeLines( l.result.files$r1, s.output.file.list.r1  )

if( !is.null( l.result.files$r2 ) )
{
	writeLines( l.result.files$r2, s.output.file.list.r2  )

} else
{

	#no files for r2, so we simply return an ampty file list
	system( paste( "touch", s.output.file.list.r2,sep=" " )  )
}#end if r2 list else ot


