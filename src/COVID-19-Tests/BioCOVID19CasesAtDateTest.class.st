"
A BioCOVID19CasesAtDateTest is a test class for testing the behavior of BioCOVID19CasesAtDate
"
Class {
	#name : #BioCOVID19CasesAtDateTest,
	#superclass : #TestCase,
	#instVars : [
		'cbd'
	],
	#category : #'COVID-19-Tests-Visualization'
}

{ #category : #accessing }
BioCOVID19CasesAtDateTest >> cbd [
	^ cbd
]

{ #category : #accessing }
BioCOVID19CasesAtDateTest >> cbd: anObject [
	cbd := anObject
]

{ #category : #accessing }
BioCOVID19CasesAtDateTest >> setUp [

	self cbd: BioCOVID19CasesAtDate new.

]

{ #category : #test }
BioCOVID19CasesAtDateTest >> testConfirmedCases [

	self assert: self cbd confirmedCases isNil.
	self cbd confirmedCases: 1.
	self assert: (self cbd confirmedCases isKindOf: Number).
]

{ #category : #test }
BioCOVID19CasesAtDateTest >> testDate [

	self assert: self cbd date isNil.
	self cbd date: '01/01/2020' asDate.
	self assert: (self cbd date isKindOf: Date).
	self assert: self cbd date equals: '01/01/2020' asDate.
]

{ #category : #test }
BioCOVID19CasesAtDateTest >> testDeathCases [

	self assert: self cbd deathCases isNil.
	self cbd deathCases: 1.
	self assert: (self cbd deathCases isKindOf: Number).
]

{ #category : #test }
BioCOVID19CasesAtDateTest >> testRecoveredCases [

	self assert: self cbd recoveredCases isNil.
	self cbd recoveredCases: 1.
	self assert: (self cbd recoveredCases isKindOf: Number).
]
