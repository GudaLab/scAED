#!/bin/bash
#SBATCH --time=7-00:00:00
#SBATCH --job-name=8.3_Copy_Merged_Unknown_Cells
#SBATCH --output=/storage/work/japatel/cancer/tumor_barcodes/8.3_Copy_Merged_Unknown_Cells.out
#SBATCH --error=/storage/work/japatel/cancer/tumor_barcodes/8.3_Copy_Merged_Unknown_Cells.err
#SBATCH --mem=240G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=50

# Define the base directory
base_dir="/path/cell_sc_bams/cell_type_1_sc_bams/cell_type_1_sorted_bams/ATACorrect/_bound_output/"

# Define the destination directory
destination_dir="/path/cell_sc_bams/cell_type_1_sc_bams/cell_type_1_merged_bed/"

# Create the destination directory if it does not exist
mkdir -p "$destination_dir"

# Copy all found *_merged.bed files to the destination directory
find "$base_dir" -mindepth 2 -type f -name "*_merged.bed" -exec cp {} "$destination_dir" \;

echo "All files have been copied to $destination_dir"