# Import module
module load tobias

# Define common paths as variables
motifs_path="/JASPAR2022.txt"
genome_path="/path/GRCh38/fasta/genome.fa"
peak_header_path="/path/peaks.narrowPeakheader.txt"
base_path="/path/tumor_barcodes/cell_type_1_sc_bams/cell_type_1_sorted_bams/ATACorrect"
peaks_path="/path/tumor_barcodes/cell_type_1_sc_bams/cell_type_1_name_sorted_bams/Genrich_Output"

# Total number of tasks
total_tasks=279

# Array of sample IDs
samples=(
"AAACCGGCAGCTAATT-1"
"AAAGCAAGTCGACTCC-1"
"AAAGCAAGTTCCGGCT-1"
"AAAGCACCATTATCCC-1"
"AAAGCGGGTCATTACC-1"
"CACCAACCAATTTGGT-1"
"CACCTGTTCGAGCTAT-1"
"CACTTTGTCTCCTCAA-1"
"CAGCTATAGCGCTAAT-1"
"CATCACACACAGGAAT-1"
"CATCACACAGGGAGGA-1"
"CCAAACCCAGGATTAA-1"
"CCACAGGGTGTAATAC-1"
"CCACAGGGTTCGCTCA-1"
"CCATAAATCAATAGCC-1"
"CCCAACCGTCCTCCAA-1"
"CCCTCACCATAAACCT-1"
"CCCTCAGTCGGTACGC-1"
"TTTATGGAGCAAGGAC-1"
"TTTCGTCCAATTAAGG-1"
"TTTCTTGCAGCCAGAA-1"
"TTTGACCGTGCAATGC-1"
"TTTGGTAAGCTAATCA-1"
".................."
)

# Calculate the number of samples per task
samples_per_task=$(( (${#samples[@]} + total_tasks - 1) / total_tasks ))

# Calculate the start and end indices for the current array task
start_index=$((SLURM_ARRAY_TASK_ID * samples_per_task))
end_index=$((start_index + samples_per_task - 1))
if [ $end_index -ge ${#samples[@]} ]; then
    end_index=$((${#samples[@]} - 1))
fi

# Function to run the BINDetect command for a given sample
run_bindetect() {
    local sample=$1

    # Check if the files exist
    if [ ! -f "${base_path}/${sample}_atacseq_footprints.bw" ] || [ ! -f "${peaks_path}/${sample}_atacseq_sorted_n.narrowPeak" ]; then
        echo "Files for sample $sample are missing. Skipping..."
        return
    fi

    # Create output directory
    OUTDIR="${base_path}/${sample}_BinDetect"
    mkdir -p "$OUTDIR"

    # Run BINDetect
    echo "Running BINDetect for sample: $sample"
    TOBIAS BINDetect --motifs "$motifs_path" \
        --signals "${base_path}/${sample}_atacseq_footprints.bw" \
        --genome "$genome_path" \
        --peaks "${peaks_path}/${sample}_atacseq_sorted_n.narrowPeak" \
        --peak_header "$peak_header_path" \
        --outdir "$OUTDIR"

    echo "BINDetect processing completed for sample: $sample"
}

# Loop over the samples in the current batch and run BINDetect in parallel
for i in $(seq $start_index $end_index); do
    sample="${samples[$i]}"
    run_bindetect "$sample" &
    # Limit the number of concurrent jobs to 30
    if (( (i - start_index + 1) % 30 == 0 )); then
        wait
    fi
done
wait