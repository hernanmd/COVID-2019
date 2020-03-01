Class {
	#name : #BioCOVID19CasesAtDate,
	#superclass : #Object,
	#instVars : [
		'confirmedCases',
		'recoveredCases',
		'deathCases',
		'date'
	],
	#category : #'COVID-19-Visualization'
}

{ #category : #accessing }
BioCOVID19CasesAtDate >> confirmedCases [
	^ confirmedCases
]

{ #category : #accessing }
BioCOVID19CasesAtDate >> confirmedCases: anObject [
	confirmedCases := anObject
]

{ #category : #accessing }
BioCOVID19CasesAtDate >> date [
	^ date
]

{ #category : #accessing }
BioCOVID19CasesAtDate >> date: anObject [
	date := anObject
]

{ #category : #accessing }
BioCOVID19CasesAtDate >> deathCases [
	^ deathCases
]

{ #category : #accessing }
BioCOVID19CasesAtDate >> deathCases: anObject [
	deathCases := anObject
]

{ #category : #accessing }
BioCOVID19CasesAtDate >> recoveredCases [
	^ recoveredCases
]

{ #category : #accessing }
BioCOVID19CasesAtDate >> recoveredCases: anObject [
	recoveredCases := anObject
]
