# Introduction

Analysis of Coronavirus outbreak data with Pharo 8.x

# Installation

```smalltalk
Metacello new
   baseline: 'COVID19';
   repository: 'github://hernanmd/COVID-2019/src';
   load.
```

# Usage

For visualization of cases as provied by CSSEGISandData, evaluate in Pharo 8:

```smalltalk
BioCOVID19Viz exampleLiveData
```

For genomic analysis install [BioSmalltalk](https://github.com/hernanmd/BioSmalltalk) and load and evaluate the do_analysis.st script.

# Sample output

![](https://user-images.githubusercontent.com/4825959/75620782-ec299d80-5b6b-11ea-918a-8cee8d3aa419.png)
