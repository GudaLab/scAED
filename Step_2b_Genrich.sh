# Define paths
GENRICH_DIR="/storage/multiome/Genrich"
GENRICH_EXECUTABLE="${GENRICH_DIR}/Genrich"

# Read the total number of BAM files from the generated list
TOTAL_BAMS=$(wc -l < cell_name_sorted_bam.txt)

# Calculate the BAM index for this task
OFFSET=$(($SLURM_ARRAY_TASK_ID * 1000))
END_OFFSET=$(($OFFSET + 1000))

for (( IDX=$OFFSET; IDX<$END_OFFSET && IDX<$TOTAL_BAMS; IDX++ )); do
    # Calculate line number considering file starts at line 1
    LINE_NUM=$(($IDX + 1))
    
    # Read the BAM file path for the calculated line number
    BAM_FILE=$(sed -n "${LINE_NUM}p" cell_name_sorted_bam.txt)
    
    if [ ! -z "$BAM_FILE" ]; then
        # Extract directory and base name for output
        DIR=$(dirname "${BAM_FILE}")
        BASENAME=$(basename "${BAM_FILE}" "_name_sorted.bam")
        
        # Create output directory inside the BAM file's directory
        OUTPUT_DIR="${DIR}/Genrich_Output"
        mkdir -p "${OUTPUT_DIR}"
        
        # Define output file path
        OUTPUT_FILE="${OUTPUT_DIR}/${BASENAME}_sorted_n.narrowPeak"
        
        # Run Genrich
        echo "Running Genrich for ${BAM_FILE}" >> "${OUTPUT_DIR}/run.log"
        "${GENRICH_EXECUTABLE}" -t "${BAM_FILE}" -o "${OUTPUT_FILE}" -v

        # Check for errors
        if [ $? -ne 0 ]; then
            echo "Error processing ${BAM_FILE}" >> "${OUTPUT_DIR}/error.log"
        fi
    fi
done