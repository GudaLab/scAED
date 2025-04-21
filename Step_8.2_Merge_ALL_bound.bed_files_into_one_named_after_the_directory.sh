# Define the base directory
base_dir="path/cell_sc_bams/cell_type_1_sc_bams/cell_type_1_sorted_bams/ATACorrect/_bound_output"

# Navigate to the base directory
cd "$base_dir"

# Check the current directory and print
echo "Working in directory: $(pwd)"

# Create a function to merge files in each directory
merge_files() {
    local dir="$1"
    echo "Processing directory: $dir"
    
    # Navigate into the directory
    cd "$dir"
    
    # Merge all *_bound.bed files into one, named after the directory
    cat *_bound.bed > "${dir}_merged.bed"
    echo "Merged files into: ${dir}_merged.bed"
    
    # Move back up to the base directory
    cd "$base_dir"
}

# Get the list of directories to process
dirs=($(find . -maxdepth 1 -type d -name "*_BinDetect"))

# Calculate the number of directories per task
num_dirs=${#dirs[@]}
dirs_per_task=90  # 102 directories per task, based on your requirement

# Calculate the start and end indices for the current task
start_idx=$(( SLURM_ARRAY_TASK_ID * dirs_per_task ))
end_idx=$(( start_idx + dirs_per_task - 1 ))

# Ensure the end index does not exceed the number of directories
if [ $end_idx -ge $num_dirs ]; then
    end_idx=$(( num_dirs - 1 ))
fi

# Process the directories assigned to this task
for (( i=start_idx; i<=end_idx; i++ )); do
    merge_files "${dirs[$i]}"
done

# List all the merged files
echo "Merged files are:"
find . -name "*_merged.bed"