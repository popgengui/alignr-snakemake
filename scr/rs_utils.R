
get.file.vector=function( s.file.list ) 
{
	#s.file.list should provide, on each line,
	#an existing file, according to path, full or relative:
	v.files =  readLines( s.file.list)
	return( v.files  )
}#end function get_file_vector

validate.paired.fastq.file.lists=function( v.read.one.fastqs, v.read.two.fastqs )
{
	l.results=list( valid = TRUE, message = "" )

	i.l1=length( v.read.one.fastqs )
	i.l2=length( v.read.two.fastqs )

	#always validate the list for R1 files:
	b.valid = all.files.exist( v.read.one.fastqs )

	if( b.valid == FALSE )
	{
		l.results$valid = FALSE
		l.results$message = paste0( "One or more files in the ",
					    "first file list does not exist." )
	}#end if invalid

	if( i.l2 != 0 )
	{
		if( i.l1 != i.l2 )
		{
			l.results$valid = FALSE
			l.results$message = paste0( l.results$message, 
					" The file list for Read 2 fastqs",
					 "is not empty, but does not equal",
					 "the number of files Raad 1 fastqs." )
		}#end if unequal lengths
		
		b.valid = all.files.exist( v.read.two.fastqs )	

		l.results$message = paste0( l.results$message, 
					  " One or more files in the ", 
					  "second fastq list does not exist" )
	}
	
	return( l.results )

}#end function validate.file.lists

all.files.exist = function( v.file.names )
{
	b.truefalse = FALSE
	b.truefalse = all( file.exists( v.file.names ) )	
	return ( b.truefalse )
}#end all.files.exist
