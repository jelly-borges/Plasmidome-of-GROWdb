#!/bin/bash

source activate platon

export PLATON_DB=/scratch/guatney/db

#Path to a text file containing sample name in column 1 and sample path in column 2
#samplenamespath="/data/GROW/list_of_samples_158_megahit_assembly_paths.txt"
samplenamespath="/data/GROW/list_of_samples_158_megahit_assembly_paths.txt"

#Initialize arrays for input sample names and sample paths
samples=()
#samplepaths=()

#Read sample names file in line by line and push contents of each column to corresponding array
while IFS=$'\t' read -r sample samplepath; do
    # Append each line to the array
    samples+=("$sample")
    #samplepaths+=("$samplepath")
done < "$samplenamespath"

#path to JGI_download directory where the samples are stored
JGIdir="/data/GROW/JGI_download"

Byrondir="/data/GROW/Byron_data"

megahitsuffix="assembly/megahit/megahit_out"
#megahitfile="final.contigs.fa"

#Check that each sample exists in JGIdir
for sample in "${samples[@]}";
do
    echo $sample
    JGIpath=${JGIdir}/${sample}
    inputpath=${JGIpath}/${megahitsuffix}/${sample}_B_1000.fa
    if [ -d ${JGIpath} ]; then
        if [ -f ${inputpath} ]; then
            #reformat.sh in="${JGIpath}/${megahitsuffix}/${megahitfile}" out="${JGIpath}/${megahitsuffix}/${sample}_B_1000.fa"
            platon ${inputpath} --verbose --meta --output ${JGIpath}/${megahitsuffix}/platonreal
        else
            echo "${sample} does not have input file"
        fi
    else
        Byronpath=${Byrondir}/${sample}
        inputpath=${Byronpath}/${megahitsuffix}/${sample}_B_1000.fa
        if [ -f ${inputpath} ]; then
            platon ${inputpath} --verbose --meta --output ${Byronpath}/${megahitsuffix}/platonreal
        else
            echo "${sample} does not have input file"
        fi
    fi
done
