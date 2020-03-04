"
BioCOVID19GenomicAnalysis alignSeqs.

"
Class {
	#name : #BioCOVID19GenomicAnalysis,
	#superclass : #Object,
	#category : #'COVID-19-Genomics'
}

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> alignSeqs [
	" Align the COVID-19 sequences "

	self alignSeqs: (self fetchSeqs: self collectSeqs)
]

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> alignSeqs: aBioESearchResult [

	self alignWithMAFFT: (self parseSeqs: aBioESearchResult).

]

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> alignWithAGA: aBioFastaMultiRecord [
	" Aligh with AGA "

	(Smalltalk at: #BioAGAWrapper) new 
		inGenBankRef: nil;
		inFastaQuery: aBioFastaMultiRecord;
		outFastaAlign: self outputAGAFilename;
		execute.

]

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> alignWithMAFFT: aBioFastaMultiRecord [

	" Aligh with MAFFT "
	(Smalltalk at: #BioMAFFTWrapper) new 
		auto;
		maxiterate: 1000;
		input: aBioFastaMultiRecord;
		addOutputParameter: self outputMAFFTFilename;
		execute.

]

{ #category : #accessing }
BioCOVID19GenomicAnalysis class >> buildReportFromMultiFasta: multi_fasta [

	self outputReportFilename asFileReference writeStreamDo: [ : writeStream | 
		writeStream 
			nextPutAll: 'Available genomes so far: ', multi_fasta size asString; 
			lf;
			nextPutAll: 	'Any gaps in the sequenced genomes? ' , multi_fasta hasGaps asString ].
	self inform: 'Written output report: ' , self outputReportFilename.

		
		
]

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> collectSeqs [
	" Answer a <Collection> of <String> each one representing a COVID-19 accession number "

	^ (((self class organization listAtCategoryNamed: #accessions) 
			collect: [ : sel | self perform: sel ])
				joinUsing: Array empty)
					asSet.

]

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> fetchSeqs: allSeqs [

	^ (Smalltalk at: #BioEntrezClient) new nuccore
			uids: allSeqs;
			setFasta;
			setModeText;
			fetch.


]

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> inspectMultiFasta: multi_fasta [

	multi_fasta gcContent inspectWithLabel: 'GC-content percentage of each sequence '.
	multi_fasta gcSkew inspectWithLabel: 'GC-skew index of each sequence '.	
	multi_fasta occurrencesOfLetters inspectWithLabel: 'Occurrences of nucleotides '.
]

{ #category : #accessing }
BioCOVID19GenomicAnalysis class >> outputAGAFilename [
	" Answer a <String> representing the output file name "

	^ String streamContents: [ : stream |
		stream
			nextPutAll: 'COVID-19-AGA-';
			nextPutAll: (DateAndTime current printYMDHMSeparatedBy: $_);
			nextPutAll: '.aln'
		 ]
]

{ #category : #accessing }
BioCOVID19GenomicAnalysis class >> outputMAFFTFilename [
	" Answer a <String> representing the output file name "

	^ String streamContents: [ : stream |
		stream
			nextPutAll: 'COVID-19-MAFFT-';
			nextPutAll: (DateAndTime current printYMDHMSeparatedBy: $_);
			nextPutAll: '.aln'
		 ]
]

{ #category : #accessing }
BioCOVID19GenomicAnalysis class >> outputReportFilename [
	" Answer a <String> representing the output file name "

	^ String streamContents: [ : stream |
		stream
			nextPutAll: 'COVID-19-report-';
			nextPutAll: (DateAndTime current printYMDHMSeparatedBy: $_);
			nextPutAll: '.txt'
		 ]
]

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> parseSeqs: aBioEntrezObject [

	| multi_fasta complete_genomes |

	multi_fasta := (Smalltalk at: #BioParser) parseMultiFasta: aBioEntrezObject result. 
	self buildReportFromMultiFasta: multi_fasta.

	" Select only complete genomes "
	complete_genomes := multi_fasta select: [ : f | f name endsWith: 'complete genome' ].
	" Group by sequence length "
	complete_genomes groupedBySeqLength inspectWithLabel: 'Complete genomes grouped by sequence length'.
	
	^ complete_genomes.

]

{ #category : #alignment }
BioCOVID19GenomicAnalysis class >> runAlignment [
	<example>

	^ self alignSeqs 
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

	^ #('MN988713' 'MN997409' 'MN994467' 'MN985325' 'MT039887' 'MT039888' 'MT027062' 'MT027063' 'MT027064' 'MT020880' 'MT020881' 'MN994468' 'MT106054' 'MT106052' 'MT106053' 'MT118835').

]
