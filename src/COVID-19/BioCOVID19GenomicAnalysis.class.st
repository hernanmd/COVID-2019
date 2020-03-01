Class {
	#name : #BioCOVID19GenomicAnalysis,
	#superclass : #Object,
	#category : #'COVID-19-Genomics'
}

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> alignSeqs [

	| all_seqs entrez_search multi_fasta complete_genomes |

	" The NCBI FTP directory is 0:/genomes/genbank/viral/Wuhan_seafood_market_pneumonia_virus/"

	all_seqs := ((self class organization listAtCategoryNamed: #accessions) 
		collect: [ : sel | self perform: sel ])
			joinUsing: Array empty.

	self fetchSeqs: all_seqs.

]

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> alignWithMAFFT: complete_genomes [

	" Aligh with MAFFT "
	(Smalltalk at: #BioMAFFTWrapper) new 
		auto;
		maxiterate: 1000;
		input: complete_genomes;
		addOutputParameter: 'mafft_output.align';
		execute.

]

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> fetchSeqs: allSeqs [

	| entrez_search multi_fasta complete_genomes |

	entrez_search := (Smalltalk at: #BioEntrezClient) new nuccore
			uids: allSeqs;
			setFasta;
			setModeText;
			fetch.
	multi_fasta := (Smalltalk at: #BioParser) parseMultiFasta: entrez_search result. 
	" Genomes so far "
	multi_fasta size.
	" GC-content percentage of each Genome "
	multi_fasta gcContent.
	" Occurrences of nucleotides "
	multi_fasta occurrencesOfLetters.
	" Select only complete genomes "
	complete_genomes := multi_fasta select: [ : f | f name endsWith: 'complete genome' ].
	" Group by sequence length "
	complete_genomes groupedBySeqLength.
	" Any gaps in the sequenced genomes? "
	complete_genomes hasGaps.

	self alignWithMAFFT: complete_genomes.

]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromAustralia [

	^ #('MT007544').



]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromChina [

	^ #('NC_045512' 'LR757998' 'LR757997' 'LR757996' 'LR757995' 'MN908947' 'MN975266' 'MN938389' 'MN938388' 'MN975262' 'MN975264' 'MN938385' 'MN938386' 'MN975267' 'MN975268' 'MN938390' 'MN975263' 'MN938387' 'MN975265' 'MN938384' 'MN988669' 'MN988668' 'MN996527' 'MN996528' 'MN996529' 'MN996530' 'MN996531').

]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromItaly [

	^ #('MT008022' 'MT008023').



]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromUSA [

	^ #('MN988713' 'MN997409' 'MN994467' 'MN994468' 'MN985325').

]
