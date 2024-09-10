#!/bin/bash

#This is the pipeline script for identifying the plasmidome in the same samples as Borton et al. (2023)
#https://www.biorxiv.org/content/10.1101/2023.07.22.550117v2

#Path to a text file containing sample name in column 1 and sample path in column 2
samplenamespath="/data/GROW/list_of_samples_158_megahit_assembly_paths.txt"

#Initialize arrays for input sample names and sample paths
samples=()
samplepaths=()

#Read sample names file in line by line and push contents of each column to corresponding array
while IFS=$'\t' read -r sample samplepath; do
    # Append each line to the array
    samples+=("$sample")
    #samplepaths+=("$samplepath")
done < "$samplenamespath"

#path to JGI_download directory where the samples are stored
JGIdir="/data/GROW/JGI_download"
Byrondir="/data/GROW/Byron_data"
#metaSPAdessuffix="assembly/JGI_metaspades"
#metaSPAdesfile="assembly.contigs.fasta"
megahitsuffix="assembly/megahit/megahit_out"
megahitfile="final.contigs.fa"

#Check that each sample exists in JGIdir
for sample in "${samples[@]}";
do
    #echo $sample
    JGIpath="${JGIdir}/${sample}"
    if [ -d ${JGIpath} ]; then
        reformat.sh in="${JGIpath}/${megahitsuffix}/${megahitfile}" out="${JGIpath}/${megahitsuffix}/${sample}_B_1000.fa" minlength=1000 ow=t
        #reformat.sh in=${JGIpath}/${metaSPAdessuffix}/${metaSPAdesfile} out=${JGIpath}/${metaSPAdessuffix}/${sample}_C_1000.fa
    else
        Byronpath="${Byrondir}/${sample}"
        reformat.sh in="${Byronpath}/${megahitsuffix}/${megahitfile}" out="${Byronpath}/${megahitsuffix}/${sample}_B_1000.fa" minlength=1000 ow=t
        #reformat.sh in=${Byronpath}/${metaSPAdessuffix}/${metaSPAdesfile} out=${Byronpath}/${metaSPAdessuffix}/${sample}_C_1000.fa
    fi
done
