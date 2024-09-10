#!/bin/bash

source activate platon

export PLATON_DB=/home/guatney/platon/db

#This is script for identifying the plasmidome in the same samples as Borton et al. (2023)
#https://www.biorxiv.org/content/10.1101/2023.07.22.550117v2

#Path to a text file containing sample name in column 1 and sample path in column 2
#samplenamespath="/data/GROW/list_of_samples_158_megahit_assembly_paths.txt"
samplenamespath="testset.txt"

#Initialize arrays for input sample names and sample paths
samples=()
#samplepaths=()

#Read sample names file in line by line and push contents of each column to corresponding array
while IFS=$'     ' read -r sample samplepath; do
    # Append each line to the array
    samples+=("$sample")
    #samplepaths+=("$samplepath")
done < "$samplenamespath"

#path to JGI_download directory where the samples are stored
JGIdir="/data/GROW/JGI_download"
metaSPAdessuffix="assembly/JGI_metaspades"
metaSPAdesfile="assembly.contigs.fasta"

#Check that each sample exists in JGIdir
for sample in "${samples[@]}";
do
    echo $sample
    JGIpath=${JGIdir}/${sample}
    inputpath=${JGIpath}/${metaSPAdessuffix}/${sample}_C_1000.fa
    if [ -f ${inputpath} ]; then
        #reformat.sh in="${JGIpath}/${megahitsuffix}/${megahitfile}" out="${JGIpath}/${megahitsuffix}/${sample}_B_1000.fa"
        platon ${inputpath} --verbose --output ${JGIpath}/${metaSPAdessuffix}/platon
    else
        echo "${sample} does not have input file"
    fi
done
