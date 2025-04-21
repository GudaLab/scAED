# import module
module load parallel/20240322
module load tobias/0.17.0

# Environment Variables
GENOME="/path/to/genome.fa"
BLACKLIST="/path/to/hg38.blacklist.bed"
export GENOME BLACKLIST

# List of directories to process
DIRS=(
    "cell_sc_bams/cell_type_1_sc_bams"
    "cell_sc_bams/cell_type_2_sc_bams"
    "cell_sc_bams/cell_type_3_sc_bams"
    "cell_sc_bams/cell_type_4_sc_bams"
    "cell_sc_bams/cell_type_5_sc_bams"
    "cell_sc_bams/cell_type_6_sc_bams"

)

# Generate bam_peak_list.txt with absolute paths and debug statements
rm -f bam_peak_list.txt

# Function to generate peak file path
get_peak_file_path() {
    local bam_file="$1"
    local root_dir="$2"
    local base_name="$3"

    local peak_file="${root_dir}/name_sorted_bams/Genrich_Output/${base_name}_atacseq_sorted_n.narrowPeak"
    echo "$peak_file"
}

# Create bam_peak_list.txt with corresponding BAM and Peak file pairs
for ROOT_DIR in "${DIRS[@]}"; do
    echo "Processing directory: ${ROOT_DIR}"
    
    # Ensure that ROOT_DIR exists before running find
    if [[ -d "${ROOT_DIR}" ]]; then
        find "${ROOT_DIR}" -type f -name "*_atacseq_sorted.bam" | while IFS= read -r bam_file; do
            base_name=$(basename "${bam_file}" "_atacseq_sorted.bam")
            peak_file=$(get_peak_file_path "$bam_file" "$ROOT_DIR" "$base_name")
            echo "Processing BAM file: ${bam_file}"
            echo "Corresponding Peak file: ${peak_file}"
            
            # Check if both BAM and Peak files exist
            if [[ -f "${bam_file}" && -f "${peak_file}" ]]; then
                echo "${bam_file} ${peak_file}" >> bam_peak_list.txt
            else
                echo "ERROR: Either ${bam_file} or ${peak_file} does not exist." >> bam_peak_list_errors.txt
            fi
        done
    else
        echo "ERROR: Directory ${ROOT_DIR} does not exist." >> bam_peak_list_errors.txt
    fi
done

# Ensure bam_peak_list.txt exists and is not empty before processing
if [[ -s bam_peak_list.txt ]]; then
    # Function to process each BAM file
    process_bam() {
        bam_file="$1"
        peak_file="$2"
        output_dir="${bam_file%/*}/ATACorrect"

        mkdir -p "${output_dir}"
        echo "Running TOBIAS ATACorrect for ${bam_file}..."
        TOBIAS ATACorrect --bam "${bam_file}" --genome "${GENOME}" --peaks "${peak_file}" --blacklist "${BLACKLIST}" --outdir "${output_dir}"
    }

    # Export necessary functions and variables for parallel execution
    export -f process_bam
    export GENOME BLACKLIST

    # Use GNU Parallel to process BAM files in parallel
    parallel --jobs 128 --colsep ' ' process_bam :::: bam_peak_list.txt
else
    echo "ERROR: bam_peak_list.txt is empty or missing."
fi
