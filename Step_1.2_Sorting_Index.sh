# Set the number of threads per BAM operation
THREADS_PER_OP=8

# Import module
module load samtools/1.17

# Function to process a BAM file, using the set number of threads
process_bam() {
    BAM_FILE="$1"
    INPUT_DIR="$2"
    OUTPUT_DIR="$3"
    THREADS="$4"
    BASENAME=$(basename "${BAM_FILE}" ".bam")

    SORTED_BAM_FILE="${OUTPUT_DIR}/${BASENAME}_sorted.bam"
    NAME_SORTED_BAM_FILE="${OUTPUT_DIR}/${BASENAME}_name_sorted.bam"

    # Sort by genomic coordinates and index
    samtools sort -o "${SORTED_BAM_FILE}" -@ ${THREADS} "${BAM_FILE}"
    samtools index "${SORTED_BAM_FILE}"

    # Sort by name
    samtools sort -n -o "${NAME_SORTED_BAM_FILE}" -@ ${THREADS} "${BAM_FILE}"
}

export -f process_bam

ROOT_DIR="/storage/multiome/sc_bams/FS4/"
cd "${ROOT_DIR}"

# Adjust for batch processing
BATCH_SIZE=600
find . -type d -name "*_sc_bams" | while read INPUT_DIR; do
    echo "Processing directory: ${INPUT_DIR}"

    # Create a corresponding output directory for each input directory
    OUTPUT_DIR="${INPUT_DIR}_output"
    mkdir -p "${OUTPUT_DIR}"  # Create output directory if it doesn't exist
    
    COUNTER=0
    declare -a JOBS=()

    for BAM_FILE in "${INPUT_DIR}"/*.bam; do
        ((COUNTER++))
        process_bam "${BAM_FILE}" "${INPUT_DIR}" "${OUTPUT_DIR}" "${THREADS_PER_OP}" &
        JOBS+=($!)

        # Wait after processing each batch of 600 files
        if (( COUNTER % BATCH_SIZE == 0 )); then
            wait "${JOBS[@]}"
            JOBS=()
        fi
    done

    # Wait for any remaining jobs from the last batch
    wait "${JOBS[@]}"
done

echo "BAM processing completed on node $NODE_NAME."
