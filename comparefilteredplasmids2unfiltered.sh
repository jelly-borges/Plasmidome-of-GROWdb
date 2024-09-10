#!/bin/bash
# A run of the example files of mmvec to make sure it works
#SBATCH --job-name=rsyncGROW
#SBATCH --partition=math-colibri
#SBATCH --nodes=12                   # Number of requested nodes
#SBATCH --time=1:00:00              # Max wall-clock time
#SBATCH --ntasks=1                 # Total number of tasks over all nodes, max 64*nodes

#Path to a text file containing sample name in column 1 and sample path in column 2
samplenamespath="/home/guatney/plasmidome/list_of_samples_158_megahit_assembly_paths.txt"

#path to JGI_download and Byron directories where the samples are stored
JGIdir="/data/GROW/JGI_download"

Byrondir="/data/GROW/Byron_data"

megahitsuffix="assembly/megahit/megahit_out"

filteredir="/home/guatney/plasmidome/filteredplaton"

#Read sample names file in line by line and push contents of each column to corresponding array
while IFS=$'\t' read -r sample samplepath; do
    JGIpath=${JGIdir}/${sample}
    inputpath=${JGIpath}/${megahitsuffix}/platonreal/${sample}_B_1000.tsv
    if [ -f $inputpath ]; then
        #path to platon output TSV file on miller-lab
        unfilteredlines=$(wc -l < $inputpath)
        unfilteredplasmids=$((unfilteredlines - l)) #don't count header
        filteredlines=$(wc -l < ${filteredir}/${sample}_B_1000_filtered.csv)
        filteredplasmids=$((filteredlines - 1)) #don't count header
        echo ${sample},${filteredplasmids},${unfilteredplasmids} >> filter2unfilter.csv

    else
        #echo n
        Byronpath=${Byrondir}/${sample}
        inputpath=${Byronpath}/${megahitsuffix}/platonreal/${sample}_B_1000.tsv
        unfilteredlines=$(wc -l < $inputpath)
        unfilteredplasmids=$((unfilteredlines - l)) #don't count header
        filteredlines=$(wc -l < ${filteredir}/${sample}_B_1000_filtered.csv)
        filteredplasmids=$((filteredlines - 1)) #don't count header
        echo ${sample},${filteredplasmids},${unfilteredplasmids} >> filter2unfilter.csv
    fi
done < "$samplenamespath"
