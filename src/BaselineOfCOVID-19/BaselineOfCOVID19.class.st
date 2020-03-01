Class {
	#name : #BaselineOfCOVID19,
	#superclass : #BaselineOf,
	#category : #'BaselineOfCOVID-19'
}

{ #category : #baselines }
BaselineOfCOVID19 >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec blessing: #'baseline'. 
		spec repository: 'github://hernanmd/COVID-19/src/'.
		self projectSpecForRoassal2: spec.
		self projectSpecForDatasets: spec.
		
		spec 
			package: 'COVID-19'
			with: [ spec requires: #('Roassal2' 'Datasets') ]
	]
]

{ #category : #baselines }
BaselineOfCOVID19 >> projectSpecForDatasets: spec [

	spec
		baseline: 'PharoAI' 
		with: [ spec repository: 'github://PharoAI/Datasets' ].

]

{ #category : #baselines }
BaselineOfCOVID19 >> projectSpecForRoassal2: spec [

	spec
		baseline: 'Roassal2' 
		with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ].

]
