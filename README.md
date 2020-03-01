# Introduction

Analysis of Coronavirus outbreak data with [Pharo](https://www.pharo.org) 8.x

# Installation

```smalltalk
Metacello new
   baseline: 'COVID19';
   repository: 'github://hernanmd/COVID-2019/src';
   load.
```

# Usage

## Data Visualization

For visualization of cases as provided by CSSEGISandData, evaluate in Pharo 8:

```smalltalk
BioCOVID19Viz exampleLiveData
```

## Alignment

For genomic analysis install [BioSmalltalk](https://github.com/hernanmd/BioSmalltalk) and evaluate the following one-liner to align the sequences with MAFFT:

```smalltalk
BioCOVID19GenomicAnalysis alignSeqs.
```

To add accession numbers as they appear in the NCBI GenBank repository, edit the class side methods matching the sequencing location:

  - seqsFromChina
  - seqsFromItaly
  - seqsFromUSA
  - ...

The resulting alignment is written in 'mafft_output.align' in the Pharo image directory.

Accessions are retrieved from https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Wuhan%20seafood%20market%20pneumonia%20virus,%20taxid:2697049

## Reference Genome download

To download the latest build of the reference genome (as of 01/02/2020) from NCBI:

```smalltalk
BionCoV2019GD new download.
```

Downloaded files are located into the Pharo image directory.

# Misc

To create a GitHub Pharo project with Continuous Integration support from scrath follow [this video](https://www.youtube.com/watch?v=Wnt3OBhR18I).

# ToDo

  - Download accessions from here: https://dev.ncbi.nlm.nih.gov/core/assets/genbank/files/ncov-sequences.yaml (currently restricted access?)
  - Add sequences from GISAID
  - Evaluate MAFFT alignment quality.

# Sample output

![](https://user-images.githubusercontent.com/4825959/75620782-ec299d80-5b6b-11ea-918a-8cee8d3aa419.png)
