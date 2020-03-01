# nCoV-2019

Analysis of Coronavirus outbreak genomic data with Pharo

# Installation

For genomic analysis install BioSmalltalk from https://github.com/hernanmd/BioSmalltalk and load and evaluate the do_analysis.st script.

For visualization of cases evaluate in Pharo 8:

```smalltalk
	Metacello new
	   baseline: 'COVID-19';
	   repository: 'github://hernanmd/COVID-19';
	   load.
```
