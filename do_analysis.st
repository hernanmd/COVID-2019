| all_seqs seqs_from_china seqs_from_USA seqs_from_Italy entrez_search multi_fasta complete_genomes |

" The NCBI FTP directory is 0:/genomes/genbank/viral/Wuhan_seafood_market_pneumonia_virus/"

" Accessions retrieved from https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Wuhan%20seafood%20market%20pneumonia%20virus,%20taxid:2697049 "

" ToDo 1: Try to download accessions from here: https://dev.ncbi.nlm.nih.gov/core/assets/genbank/files/ncov-sequences.yaml (currently restricted access?) "
" ToDo 2: Add sequences from GISAID? Not available yet "

seqs_from_china := #('NC_045512' 'LR757998' 'LR757997' 'LR757996' 'LR757995' 'MN908947' 'MN975266' 'MN938389' 'MN938388' 'MN975262' 'MN975264' 'MN938385' 'MN938386' 'MN975267' 'MN975268' 'MN938390' 'MN975263' 'MN938387' 'MN975265' 'MN938384' 'MN988669' 'MN988668' 'MN996527' 'MN996528' 'MN996529' 'MN996530' 'MN996531').
seqs_from_USA := #('MN988713' 'MN997409' 'MN994467' 'MN994468' 'MN985325').
seqs_from_Italy := #('MT008022' 'MT008023').
seqs_from_Australia := #('MT007544')

all_seqs := seqs_from_china , seqs_from_USA , seqs_from_Italy , seqs_from_Australia.

entrez_search := BioEntrezClient new nuccore
			uids: seqs_from_china;
			setFasta;
			setModeText;
			fetch.
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
complete_genomes hasGaps.

" Aligh with MAFFT "
BioMAFFTWrapper new 
	auto;
	maxiterate: 1000;
	input: complete_genomes;
	addOutputParameter: 'mafft_output.align';
	execute.
