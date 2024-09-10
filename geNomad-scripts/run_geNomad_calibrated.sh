#!/bin/bash
# 2023-09-22
# chris.miller@ucdenver.edu
# started by modifying Lucia's /home/guatney/plasmidome/reverse_run_platon_megahit.sh

# This script expects a single argument, which is sample name
# So you get sample from the command line (will use parallel and sample file to generate these)
# samplenames="/data/GROW/list_of_samples_158.txt" # single column

# get single sample from command line argument
sample=$1
mincontigsize=1000  # 1000 or 2500

# source activate genomad # not needed if parallel run in active conda env.

#path to JGI_download directory where the samples are stored
JGIdir="/data/GROW/JGI_download"
Byrondir="/data/GROW/Byron_data"
megahitsuffix="assembly/megahit/megahit_out"

genomad_db="/scratch/chris/geNomad/genomad_db"
outputdir="/scratch/chris/geNomad/genomad_output_calibrated"
mkdir -p $outputdir

#Find correct sample path and set $inputpath
echo Working on $sample at `date` on $HOSTNAME

# DEBUG:
# genomad --version
# sleep 10s
# exit

JGIpath=${JGIdir}/${sample}
inputpath=${JGIpath}/${megahitsuffix}/${sample}_B_${mincontigsize}.fa
if [ -d ${JGIpath} ]; then  # this is in the JGI directory
    if [ -f ${inputpath} ]; then
        echo "using inputpath ${inputpath}"
    else
        echo "${sample} does not have input file"
        exit 1
    fi
else
    Byronpath=${Byrondir}/${sample}
    inputpath=${Byronpath}/${megahitsuffix}/${sample}_B_1000.fa
    if [ -f ${inputpath} ]; then
        echo "using inputpath ${inputpath}"
    else
        echo "${sample} does not have input file"
        exit 1
    fi
fi

# run it!  
# splits shrinks database size to 2 chunks to reduce memory footprint
# cleanup removes intermediate files
mkdir -p ${outputdir}/${sample}
genomad end-to-end --splits 2 \
    --cleanup \
    --threads 8 \
    --enable-score-calibration \
    $inputpath ${outputdir}/${sample} $genomad_db

