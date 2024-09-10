#!/bin/bash
# A run of the example files of mmvec to make sure it works
#SBATCH --job-name=rsyncGROW
#SBATCH --partition=math-alderaan
#SBATCH --nodes=1                   # Number of requested nodes
#SBATCH --time=1:00:00              # Max wall-clock time
#SBATCH --ntasks=1                 # Total number of tasks over all nodes, max 64*nodes

#Path to a text file containing sample name in column 1 and sample path in column 2
#samplenamespath="/data/GROW/list_of_samples_158_megahit_assembly_paths.txt"
#alderaanwdir="/storage/biology/projects/guatneyl/GROWplatonout"
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

for sample in "${samples[@]}";
do
    #check if sample is in JGI path then check for platon output. Else, check Byron path for platon output.
    JGIpath=${JGIdir}/${sample}
    if [ -d ${JGIpath} ]; then
        inputpath=${JGIpath}/${megahitsuffix}/platonreal/${sample}_B_1000.tsv
        if [ ! -f ${inputpath} ]; then
            line_count=$(wc -l ${inputpath})
            plasmid_count=$((line_count-1))
        fi
    #I have ssh keys w/ alias "lab" set up in config file so this works
    #a flag does time sync (stands for archive), v for verbose
    rsync -av --compress --compress-level 2 lab:${inputpath} $alderaanwdir
    else
        Byronpath=${Byrondir}/${sample}
        inputpath=${Byronpath}/${megahitsuffix}/platonreal/${sample}_B_1000.tsv
        if [ ! -f ${inputpath} ]; then
            millerwdir=${Byronpath}/${megahitsuffix}/platonreal
            rsync -av --compress --compress-level 2 alderaan:${alderaanwdir}/${sample}_B_1000.tsv ${millerwdir}
            rsync -av --compress --compress-level 2 alderaan:${alderaanwdir}/${sample}_B_1000.plasmid.fasta ${millerwdir}
        fi
    fi
    #platon ${alderaanwdir}/${sample}_B_1000.fa --verbose --meta --output ${alderaanwdir}/${sample}/platonreal
done