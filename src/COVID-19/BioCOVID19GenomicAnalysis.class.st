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

	^ #('MT007544' 'MT050416' 'MT050414' 'MT050417' 'MT050415' 'MT111895' 'MT111896').



]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromBelgium [

	^ #('MT072668' 'MT072667').



]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromChina [

	^ #('NC_045512' 'LR757998' 'LR757997' 'LR757996' 'LR757995' 'MN908947' 'MN975266' 'MN938389' 'MN938388' 'MN975262' 'MN975264' 'MN938385' 'MN938386' 'MN975267' 'MN975268' 'MN938390' 'MN975263' 'MN938387' 'MN975265' 'MN938384' 'MN988669' 'MN988668' 'MN996527' 'MN996528' 'MN996529' 'MN996530' 'MN996531' 'MT049951' 'MT042774' 'MT042778' 'MT042775' 'MT039873' 'MT019529'  'MT019531' 'MT019533' 'MT019530' 'MT019532' 'MT042776' 'MT042773' 'MT042777' 'MT093631' 'MT081063' 'MT081059' 'MT081060' 'MT081061' 'MT081062' 'MT081064' 'MT081065' 'MT081066' 'MT081067' 'MT081068' 'MT123291' 'MT123290'). 
]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromFinland [

	^ #('MT020781').



]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromItaly [

	^ #('MT008022' 'MT008023').



]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromJapan [

	^ #('LC522974' 'LC522975' 'LC522972' 'LC522973').

]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromMalaysia [

	^ #('MT066159' 'MT066157' 'MT066158').

]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromNepal [

	^ #('MT072688').

]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromPhilippines [

	^ #('LC522350' 'LC523809' 'LC523807' 'LC523808').

]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromSouthKorea [

	^ #('MT039890').

]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromSweden [

	^ #('MT093571').

]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromTaiwan [

	^ #('MT066175' 'MT066176').

]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromThailand [

	^ #('MN970004' 'MN970003').

]

{ #category : #accessions }
BioCOVID19GenomicAnalysis class >> seqsFromUSA [

	^ #('MN988713' 'MN997409' 'MN994467' 'MN994468' 'MN985325' 'MT039887' 'MT039888' 'MT027062' 'MT027063' 'MT027064' 'MT020880' 'MT020881' 'MN988713' 'MN994468' 'MT106054' 'MT106052' 'MT106053' 'MT118835').

]
