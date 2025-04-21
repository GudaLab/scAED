# Base directory path
base_dir="/path/cell_sc_bams/cell_type_1_sc_bams/cell_type_1_sorted_bams/ATACorrect/"

# Target directory for output
output_base_dir="${base_dir}/_bound_output"

# Create output base directory if it does not exist
mkdir -p "${output_base_dir}"

# Define the list of BinDetect directories manually
bindetect_dirs=(
"AAACAGCCAGTTGCGT-1_BinDetect"
"AAACATGCACAACAGG-1_BinDetect"
"AAACCGAAGAGGAAGG-1_BinDetect"
"AAACGTACATGTCAAT-1_BinDetect"
"AAAGCCCGTTTGCAGA-1_BinDetect"
"AAAGCCGCAAGGTAAC-1_BinDetect"
"AAAGCGGGTGCCTCAC-1_BinDetect"
"AAAGGACGTCGAAGTC-1_BinDetect"
"AAAGGAGCACAAAGCG-1_BinDetect"
"AAAGGCTCATGTTGGC-1_BinDetect"
"AAATCCGGTCTTTGAC-1_BinDetect"
"AACAGATAGCCAGGTC-1_BinDetect"
"AACAGATAGGATTTGC-1_BinDetect"
"AACCTAATCAGCAAAG-1_BinDetect"
"AACGACAAGCACTAAC-1_BinDetect"
"AACGACAAGCGGATAA-1_BinDetect"
"AACGCCCAGGCCTTAG-1_BinDetect"
"AACTACTCAATTAGCT-1_BinDetect"
"AACTAGCTCATGGCCA-1_BinDetect"
"AACTAGTGTTCCTCCT-1_BinDetect"
"AACTCACAGGCATTAC-1_BinDetect"
"AAGACAAGTAACTACG-1_BinDetect"
"............................"
)

# Calculate start and end indices for the current array task
chunk_size=16
start_index=$((SLURM_ARRAY_TASK_ID * chunk_size))
end_index=$((start_index + chunk_size - 1))
if [ $end_index -ge ${#bindetect_dirs[@]} ]; then
    end_index=$((${#bindetect_dirs[@]} - 1))
fi

# Process files in parallel within each SLURM job
for i in $(seq $start_index $end_index); do
    bindetect_dir="${base_dir}/${bindetect_dirs[$i]}"
    
    if [ -d "$bindetect_dir" ]; then
        # Extract the specific BinDetect directory name for naming the output directory
        bindetect_name=$(basename "${bindetect_dir}")
        
        # Create a specific output directory for the current BinDetect
        specific_output_dir="${output_base_dir}/${bindetect_name}"
        mkdir -p "${specific_output_dir}"
        
        # Find all bed files and copy them to the specific output directory in the background
        find "${bindetect_dir}" -type f -name "*_bound.bed" -exec cp {} "${specific_output_dir}" \; &
    fi
done

# Wait for all background processes to finish
wait

echo "Copying complete."
