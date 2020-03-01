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

{ #category : #accessing }
BioCOVID19Viz class >> install [

	Metacello new
	   baseline: 'Datasets';
	   repository: 'github://PharoAI/Datasets';
	   load.
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
		buildGrapherFor: allCases
		type: caseAccessors values
	
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
BioCOVID19Viz >> buildGrapherFor: arrayOfCases type: caseTypeSelectors [

	| ds grapher minDate lb latestStats |
	
	minDate := (arrayOfCases anyOne detectMin: #date) date.
	grapher := RTGrapher new.
	arrayOfCases with: caseTypeSelectors do: [ : caseTypeArray : caseTypeSelector |
		| lineColor |
		ds := RTData new.
		ds interaction popup.
		lineColor := self colorFor: caseTypeSelector.
		ds 	dotShape color: lineColor.
		ds 
			points: caseTypeArray;
			connectColor: lineColor;
			x: [ : aCase | aCase date julianDayNumber - minDate julianDayNumber ];
			y: caseTypeSelector.
		grapher 
			add: ds ].
	grapher axisY
		title: 'Count';
		color: Color black;		
		noDecimal.
	grapher axisX 
		title: 'Day';
		color: Color black;		
		numberOfTicks: arrayOfCases anyOne size;
		numberOfLabels: arrayOfCases anyOne size / 2;
		labelRotation: -30;
		labelConversion: [ :v | Date julianDayNumber: v + minDate julianDayNumber ].
	grapher 
		extent: 400@200;
		build.
		
	lb := RTLegendBuilder new.
	lb view: grapher view;
		top.
	lb addColoredText: 'Cases of COVID-19' color: Color black.
	latestStats := arrayOfCases anyOne last.
	lb addColoredText: 'Deaths: ' ,  latestStats deathCases asString color: Color red;
		addColoredText: 'Confirmed: ' , latestStats confirmedCases asString color: Color blue;
		addColoredText: 'Recovered: ',  latestStats recoveredCases asString color: Color green.
	lb build.
	grapher view @ RTZoomableView @ RTZoomableBoxView.
	
	grapher view inspect.


]

{ #category : #visualization }
BioCOVID19Viz >> buildTableFor: urlString [

	| dataLocation |
	dataLocation := self useLocalData
		ifTrue: [ urlString asFileReference ]
		ifFalse: [ (ZnEasy get: urlString) contents ].
	^ DataFrame 
			readFromCsv: dataLocation readStream contents 
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
		ifFalse: [ 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv' ]
		ifTrue: [ 'time_series_19-covid-Confirmed.csv' ].
]

{ #category : #constants }
BioCOVID19Viz >> urlForDeathCases [

	^ self useLocalData 
		ifFalse: [ 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv' ]
		ifTrue: [ 'time_series_19-covid-Deaths.csv' ].
]

{ #category : #constants }
BioCOVID19Viz >> urlForRecoveredCases [

	^ self useLocalData 
		ifFalse: [ 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv' ]
		ifTrue: [ 'time_series_19-covid-Recovered.csv' ].
]

{ #category : #accessing }
BioCOVID19Viz >> useLocalData [
	^ useLocalData
]

{ #category : #accessing }
BioCOVID19Viz >> useLocalData: anObject [
	useLocalData := anObject
]
