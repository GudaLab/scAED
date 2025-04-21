import os
import pysam
import logging

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Define the path to your ATAC-seq BAM file
atacseq_bam_path = '/atac_possorted_bam.bam'

# Directory where barcode files are located
barcodes_dir = '/barcodes/'

# Customize the output directory for BAM files
output_dir = '/output_folder_name/'  # Ensure this ends with a slash

# Ensure the output directory exists
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# List of barcode files for different cell types
barcode_files = [
    "cell_type_name.txt",
]

# Maximum number of files to keep open at a time
max_open_files = 50000

def process_barcodes_batch(barcodes_batch, cell_type, original_bam, header):
    barcode_file_handles = {}
    
    for barcode in barcodes_batch:
        output_bam_path = os.path.join(output_dir, cell_type, f"{barcode}_atacseq.bam")
        barcode_file_handles[barcode] = pysam.AlignmentFile(output_bam_path, "wb", header=header)

    # Iterate over reads in the original BAM file
    for read in original_bam:
        if read.has_tag('CB'):
            barcode = read.get_tag('CB')
            if barcode in barcodes_batch:
                barcode_file_handles[barcode].write(read)

    # Close all open BAM files
    for handle in barcode_file_handles.values():
        handle.close()

# Process each barcode file separately
for barcode_file in barcode_files:
    cell_type = os.path.splitext(barcode_file)[0]
    cell_type_dir = os.path.join(output_dir, cell_type)
    if not os.path.exists(cell_type_dir):
        os.makedirs(cell_type_dir)

    with open(os.path.join(barcodes_dir, barcode_file), 'r') as f:
        barcodes = [line.strip() for line in f]

    logging.info(f"Processing {len(barcodes)} barcodes from {barcode_file}")

    # Open the original BAM file and process reads
    with pysam.AlignmentFile(atacseq_bam_path, "rb") as original_bam:
        header = original_bam.header.copy()

        # Split barcodes into batches to avoid too many open files
        for i in range(0, len(barcodes), max_open_files):
            barcodes_batch = barcodes[i:i + max_open_files]
            process_barcodes_batch(barcodes_batch, cell_type, original_bam, header)
            logging.info(f"Processed batch {i // max_open_files + 1} for {cell_type}")

    logging.info(f"Filtered BAM files created for barcodes in {barcode_file}.")
