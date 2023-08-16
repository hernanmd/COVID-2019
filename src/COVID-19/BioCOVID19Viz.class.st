"
COVID-19 visualization. It supports on-line live mode, where each instantiation will retrieve the data from CSSEGISandData GitHub repository, and an off-line mode using manually downloaded CSV files, for developing purposes (visit the URL's in the constants protocol to download each).

To visualize see class side example methods.

Internal Representation and Key Implementation Points.

    Instance Variables
	confirmedCasesTable:		<Object>
	covid19Cases:		<Object>
	deathCasesTable:		<Object>
	grapher:		<Object>
	minDate:		<Object>
	recoveredCasesTable:		<Object>
	useLocalData:		<Object>


    Implementation Points
"
Class {
	#name : #BioCOVID19Viz,
	#superclass : #Object,
	#instVars : [
		'confirmedCasesTable',
		'deathCasesTable',
		'recoveredCasesTable',
		'useLocalData',
		'covid19Cases'
	],
	#category : #'COVID-19-Visualization'
}

{ #category : #accessing }
BioCOVID19Viz class >> exampleLiveData [

	self new 
		useLocalData: false;	
		build
]

{ #category : #accessing }
BioCOVID19Viz class >> exampleLocalData [

	self new
		useLocalData: true;
		build
]

{ #category : #visualization }
BioCOVID19Viz >> build [

	| caseAccessors allCases |

	self buildTables.
	caseAccessors := { 
		#confirmedCasesTable -> #confirmedCases .
		#deathCasesTable -> #deathCases .
		#recoveredCasesTable -> #recoveredCases
	 } asDictionary.
	" Build data frames for each type of cases "
	allCases := caseAccessors associations collect: [ : assoc | 
		(self 
			buildDataSetFor: (self perform: assoc key) 
			setterSelector: assoc value asMutator) ].
	self 
		buildChartFor: allCases
		type: caseAccessors values
	
]

{ #category : #visualization }
BioCOVID19Viz >> buildChartFor: arrayOfCases type: caseTypeSelectors [

	| chart minDate lb latestStats popUp dates |
	

	minDate := (arrayOfCases anyOne detectMin: #date) date.
	chart := RSCompositeChart new.

	arrayOfCases with: caseTypeSelectors do: [ : caseTypeArray : caseTypeSelector |
		| line |

		popUp := (RSPopup text: [ : assoc | (caseTypeArray perform: caseTypeSelector) asString ]).
		line := RSLinePlot new.
		line 
			addInteraction: popUp;
			x: (caseTypeArray collect: [ : aCase | aCase date julianDayNumber - minDate julianDayNumber ])
			y: (caseTypeArray collect: [ : aCase | aCase perform: caseTypeSelector ]).

		chart add: line ].

	dates := arrayOfCases anyOne collect: [ : case | case date ].

	chart horizontalTick fontSize: 4.
	chart horizontalTick 
		"fromNames: dates keys;"
		doNotUseNiceLabel;
		numberOfTicks: 20;
		labelConversion: [ : each | each isZero 
				ifFalse: [ dates at: each asInteger ] 
				ifTrue: [ dates first ] ];
		useDiagonalLabel.

	chart verticalTick integerWithCommas.
	chart chartExtents	minValueY: 0.
	chart 
		title: 'Cases of COVID-19';
		ylabel: 'Count';
		xlabel: 'Day';
		extent: 400 @ 200.
		
	latestStats := arrayOfCases anyOne last.
	chart build.
	
	lb := RSLegend new.
	lb container: chart canvas.
	{ 
		'Deaths: ' -> #deathCases .
		'Confirmed: ' -> #confirmedCases.
		'Recovered: ' -> #recoveredCases } doWithIndex: [ :lblAssoc :index |
		lb 
			text: lblAssoc key , (latestStats perform: lblAssoc value) asString
			withBoxColor: (chart plots at: index) computeColor ].
	lb location outer; innerY; top; right; offset: 30 @ 0.
	lb build.
	
	chart canvas open


]

{ #category : #visualization }
BioCOVID19Viz >> buildDataSetFor: table setterSelector: setterSelector [
	" Answer a <Collection> of <BioCOVID19CasesAtDate> objects. Receives table DataFrame and subset the columns for each day. Then at the new <DataFrame> sum all global cases for each day (column) and setup the BioCOVID19CasesAtDate for the type of case given in setterSelector. "

	^ ((table  
			columnsFrom: 5 
			to: table numberOfColumns) 
				inject: 0
				into: [ : each : accum | each + accum ])
					associations collect: [ : assoc |
						(self 
							caseAtDay: assoc key asDate 
							for: setterSelector) 
								perform: setterSelector 
								with: assoc value ].
]

{ #category : #visualization }
BioCOVID19Viz >> buildTableFor: urlString [

	| fileRef |
	fileRef := self useLocalData
		ifTrue: [ urlString asFileReference ]
		ifFalse: [ 
			self downloadResourcesFrom: urlString.
			FileSystem disk workingDirectory / urlString asZnUrl pathSegments last ].
	^ DataFrame 
			readFromCsv: fileRef readStream contents 
			withSeparator: $,
	
]

{ #category : #visualization }
BioCOVID19Viz >> buildTables [

	self confirmedCasesTable: (self buildTableFor: self urlForConfirmedCases).
	self deathCasesTable: (self buildTableFor: self urlForDeathCases).
	self recoveredCasesTable: (self buildTableFor: self urlForRecoveredCases)
]

{ #category : #accessing }
BioCOVID19Viz >> caseAtDay: aDate for: aTypeSelector [

	^ self covid19Cases 
		at: aDate
		ifAbsentPut: [ 
			BioCOVID19CasesAtDate new
				date: aDate;
				yourself ]
]

{ #category : #visualization }
BioCOVID19Viz >> colorFor: caseTypeSelector [

	^ caseTypeSelector = #deathCases
		ifTrue: [ Color red ]
		ifFalse: [ 
			caseTypeSelector = #recoveredCases
				ifTrue: [ Color green ]
				ifFalse: [ Color blue ] ]
]

{ #category : #accessing }
BioCOVID19Viz >> confirmedCasesTable [
	^ confirmedCasesTable
]

{ #category : #accessing }
BioCOVID19Viz >> confirmedCasesTable: anObject [
	confirmedCasesTable := anObject
]

{ #category : #accessing }
BioCOVID19Viz >> covid19Cases [
	^ covid19Cases
		ifNil: [ covid19Cases := Dictionary new ]
]

{ #category : #accessing }
BioCOVID19Viz >> covid19Cases: anObject [
	covid19Cases := anObject
]

{ #category : #accessing }
BioCOVID19Viz >> deathCasesTable [
	^ deathCasesTable
]

{ #category : #accessing }
BioCOVID19Viz >> deathCasesTable: anObject [
	deathCasesTable := anObject
]

{ #category : #accessing }
BioCOVID19Viz >> recoveredCasesTable [
	^ recoveredCasesTable
]

{ #category : #accessing }
BioCOVID19Viz >> recoveredCasesTable: anObject [
	recoveredCasesTable := anObject
]

{ #category : #constants }
BioCOVID19Viz >> urlForConfirmedCases [

	^ self useLocalData
		  ifFalse: [ self urlStringForConfirmedCases ]
		  ifTrue: [ 'time_series_covid19_confirmed_global.csv' ]
]

{ #category : #constants }
BioCOVID19Viz >> urlForDeathCases [

	^ self useLocalData 
		ifFalse: [ 'https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv' ]
		ifTrue: [ 'time_series_covid19_deaths_global.csv' ].
]

{ #category : #constants }
BioCOVID19Viz >> urlForRecoveredCases [

	^ self useLocalData 
		ifFalse: [ 'https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv' ]
		ifTrue: [ 'time_series_covid19_recovered_global.csv' ].
]

{ #category : #constants }
BioCOVID19Viz >> urlStringForConfirmedCases [

	^ 'https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'
]

{ #category : #accessing }
BioCOVID19Viz >> useLocalData [
	^ useLocalData
]

{ #category : #accessing }
BioCOVID19Viz >> useLocalData: anObject [
	useLocalData := anObject
]
