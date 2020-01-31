| seqs_from_china seqs_from_USA entrez_search multi_fasta complete_genomes |

" Accessions retrieved from https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Wuhan%20seafood%20market%20pneumonia%20virus,%20taxid:2697049 "
"0:/genomes/genbank/viral/Wuhan_seafood_market_pneumonia_virus/"

seqs_from_china := #('NC_045512' 'MN908947' 'MN975266' 'MN938389' 'MN938388' 'MN975262' 'MN975264' 'MN938385' 'MN938386' 'MN975267' 'MN975268' 'MN938390' 'MN975263' 'MN938387' 'MN975265' 'MN938384' 'MN988669' 'MN988668' 'MN996527' 'MN996528' 'MN996529' 'MN996530' 'MN996531').
seqs_from_USA := #('MN988713' 'MN997409' 'MN994467' 'MN994468' 'MN985325').

" Query Entrez System "
entrez_search := BioEntrezClient new nuccore
			uids: seqs_from_china;
			setFasta;
			setModeText;
			fetch.
" Parse results from Entrez "
multi_fasta := BioParser parseMultiFasta: entrez_search result. 
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
complete_genomes hasGaps
