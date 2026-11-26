'''
20261122
supporting functions for the alignr-snakemake 
workflow
'''

class SeqRegion:
	'''
	20261122: Here we assume a region entry is a 1-based 
	coordinate system expressed in form,
	"seq_name:start_coord-stop_coord"
	'''
	def __init__( self, s_seq_name, i_start, i_stop ):
		
		self.seqname=s_seq_name
		self.start=i_start
		self.stop=i_stop
		return
	#end __init__

	def getRegionSize( self ):
		return ( self.stop - self.start ) + 1
	#end def getRegionSize

	def printRegion( self ):
		print( f"{self.seqname}:{self.start}-{self.stop}"  )
		return
	#end def printRegion

#end class

def get_chunk_coords( i_sequence_length, i_chunk_size ):
	for i_start in range( 1, i_sequence_length, i_chunk_size ):
		yield i_start, i_start + ( i_chunk_size - 1)
	#end for each starting coord
#end make_chunk_coords

def make_regions_from_sequence ( s_sequence_name, 
									i_sequence_length, 
									i_chunk_size ):

	d_regions = dict( full=list(), final=None )
	for o_duple in get_chunk_coords( i_sequence_length, i_chunk_size ):

		i_this_start = o_duple[0]
		i_this_stop = o_duple[1]

		#assign to separate list item if it's the final 
		#chunk
		if i_this_start >= ( i_sequence_length - i_chunk_size ):
			i_this_stop = i_sequence_length
			d_regions[ "final" ] = SeqRegion( s_sequence_name,
										i_this_start, i_this_stop )
		else:
			d_regions[ "full" ].append( SeqRegion( s_sequence_name,
											i_this_start, i_this_stop ) )
		#end if remainder else full chunk
	#end for

	return d_regions
#end make_regions_from_sequence

def chunk_reference( s_ann_file, i_chunk_size_in_bases=int(1e7) ):
	'''
	20261122. Given a *.ann file produced by bwa indexing a 
	reference fasta sequence, and an integer i, for each sequence
	named and sized by the *.ann file, produce a set of regions,
	given as "sequence_name:start_coordinate-end_coordinate", whose
	length (size) in bases is given by i.  Coordinates are 1-based.

	This function returns a dictionary with 2 keyed lists of objects
	of class SeqRegion:
		--"full_regions" keys to a list of regions of size i (see below 
		for exceptions)
		--"remainers" keys to a list of the smaller regions at the ends
		(see below for exceptions)

	Currently, the "full_regions" list will include, for a given sequence, 
	as many regions of size i as can divide it up.  It will also inlucd any
	smaller region (at the end), if it is at least 60% the length of i.
	'''
	d_regions = dict( full_regions=list() , remainders=list() )

	s_ann_file_delimiter = " "
	i_ann_file_seq_index = 1
	i_linecount=0
	#if the region size is at least
	#this proportion of a full, treat
	#it as full:
	f_ratio_for_virtual_chunk = 0.6

	s_seq_name=None

	with open( s_ann_file ) as o_file: 
		for s_line in o_file:
			i_linecount += 1
			b_line_number_is_even = ( i_linecount % 2 ) == 0

			#first line is not informative:
			if i_linecount == 1:
				continue
			elif b_line_number_is_even:
				#entry has seq id
				s_seq_name = str.split( s_line.strip(), 
						s_ann_file_delimiter )[ i_ann_file_seq_index ] 
			else:
				#entry has seq size
				s_size=str.split( s_line.strip(), 
						s_ann_file_delimiter )[ i_ann_file_seq_index ]

				i_size=int( s_size )
				
				d_these_regions=make_regions_from_sequence( s_seq_name, 
										i_size, 
										i_chunk_size_in_bases ) 
				for o_region in d_these_regions[ "full" ]:
					d_regions[ "full_regions"].append( o_region )
				#end for each full region

				i_size_of_end_chunk = d_these_regions[ 
									"final" ].getRegionSize()

				if i_size_of_end_chunk >= ( 
						f_ratio_for_virtual_chunk * i_chunk_size_in_bases ):

					d_regions[ "full_regions" ].append(d_these_regions[ "final" ] ) 
				else:
					d_regions[ "remainders" ].append( d_these_regions[ "final" ] )
				#if remainder is big enough add it to full regions, else remainders

			#end if...elif...else
		#end for
	#end with
	return d_regions 
#end chunk_reference

