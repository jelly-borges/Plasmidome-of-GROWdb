import sys
import pandas as pd
import subprocess

#This script is intended to be run by a bash script iterating through the GROW samples listed in
#/data/GROW/list_of_xamples_158_megahit_assembly_paths.txt
#which has the sample name in one column and the path to the original megahit output in the second column.
#The bash script provides the path to the output from platon on that sample as the first argument and the
#sample name as the second argument so that I can fstring the filtered dataset into a new output file name.

#interestingly argument 0 is the name of the script which makes sense because
#python scriptname "first_argument" anotha_one
inputfile=sys.argv[1]
samplename=sys.argv[2]
#samplepath=sys.argv[3]
unfiltered=pd.read_csv(inputfile, sep = "\t")

#filter platon output to include potential plasmid contigs that have one or more line of evidence supporting plasmidness
#(excluding circularity)
#(because Chris thinks it's picking up on repeats at termini)
colstofilter=['RDS', 'Inc Type(s)', '# Replication', '# Mobilization', '# OriT', '# Conjugation', '# AMRs', '# Plasmid Hits']
filtered=unfiltered[unfiltered[colstofilter].sum(axis=1)>0]

filtered.to_csv(f'/home/guatney/plasmidome/filteredplaton/{samplename}_B_1000_filtered.csv')

#call bbmap script "filterbyname.sh" with the sample IDs that have passed the filter
outfasta=f'/home/guatney/plasmidome/filteredplaton/{samplename}.filteredplasmids.fasta'
filteredplasmids=list(filtered['ID'])
#subprocess.run(["filterbyname.sh", f"in={samplepath} out={outfasta} names={' '.join(filteredplasmids)}"])
