# Import module
module load tobias

# Base Directory for BAM files
BASE_DIR="/cell_type_1_sc_bams"

# Cell types to process and the number of files for each cell type
declare -A cell_types=(
    ["cell_type_1"]=279
)

FILES_PER_BATCH=10  # Adjust this as needed

# Loop through each cell type
for cell in "${!cell_types[@]}"; do
    ATACORRECT_DIR="${BASE_DIR}/${cell}_sc_bams/${cell}_sorted_bams/ATACorrect"
    GENRICH_OUTPUT_DIR="${BASE_DIR}/${cell}_sc_bams/${cell}_name_sorted_bams/Genrich_Output"

    # Array of all BW files for the current cell type
    ALL_FILES=(${ATACORRECT_DIR}/*_sorted_corrected.bw)
    TOTAL_FILES=${cell_types[$cell]}
    TOTAL_BATCHES=$(( (TOTAL_FILES + FILES_PER_BATCH - 1) / FILES_PER_BATCH ))

    # Debugging: print the directories and total files
    echo "Processing cell type: $cell"
    echo "ATACorrect directory: $ATACORRECT_DIR"
    echo "Genrich Output directory: $GENRICH_OUTPUT_DIR"
    echo "Total files: $TOTAL_FILES"
    echo "Total batches: $TOTAL_BATCHES"

    # Process files in batches
    for (( batch=0; batch < TOTAL_BATCHES; batch++ )); do
        START_FILE=$((batch * FILES_PER_BATCH))
        END_FILE=$((START_FILE + FILES_PER_BATCH - 1))
        SELECTED_FILES=("${ALL_FILES[@]:$START_FILE:$FILES_PER_BATCH}")

        # Debugging: print the selected files
        echo "Processing batch $batch for cell type $cell"
        echo "Selected files: ${SELECTED_FILES[@]}"

        # Process each selected file
        for CORRECTED_BW_FILE in "${SELECTED_FILES[@]}"; do
            BASENAME=$(basename "${CORRECTED_BW_FILE}" "_sorted_corrected.bw")
            NARROWPEAK_FILE="${GENRICH_OUTPUT_DIR}/${BASENAME}_sorted_n.narrowPeak"

            if [ -f "$NARROWPEAK_FILE" ]; then
                echo "Running TOBIAS FootprintScores for ${BASENAME}..."
                TOBIAS FootprintScores --signal "$CORRECTED_BW_FILE" --regions "$NARROWPEAK_FILE" --output "${ATACORRECT_DIR}/${BASENAME}_footprints.bw" --cores 10  # Increased cores from 5 to 10
            else
                echo "ERROR: NarrowPeak file does not exist: $NARROWPEAK_FILE"
            fi
        done

        echo "FootprintScore processing completed for batch $batch of cell type: $cell"
    done

    echo "FootprintScore processing completed for cell type: $cell"
done

echo "All cell types processed."
