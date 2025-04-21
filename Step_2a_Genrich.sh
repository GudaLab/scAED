#!/bin/bash

# Define root directory for all the bam files
ROOT_DIR="/cell_sc_bams"

# Find all name-sorted BAM files and save them to a list
find "${ROOT_DIR}" -type f -name "*_name_sorted.bam" > cell_name_sorted_bam.txt

# Count the number of BAM files
NUM_BAMS=$(wc -l < cell_name_sorted_bam.txt)

# Output the number of BAM files found
echo "Number of BAM files found: $NUM_BAMS"

# Check if there are any BAM files found
if [ "$NUM_BAMS" -gt 0 ]; then
    # Define the batch size for the job array
    BATCH_SIZE=1000
    
    # Calculate the number of jobs needed
    NUM_JOBS=$(( (NUM_BAMS + BATCH_SIZE - 1) / BATCH_SIZE ))

    # Submit the job with dynamically determined array size
    sbatch --array=0-$((NUM_JOBS - 1))%20 2b_Genrich.sh
else
    echo "No BAM files found. Check the directory path and file naming conventions."
fi