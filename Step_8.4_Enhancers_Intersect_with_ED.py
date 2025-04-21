import pandas as pd
import pyranges as pr
import os

# Load enhancer data
enhancer_path = '/path/hg38_final_nodup.bed'
enhancer_df = pd.read_csv(enhancer_path, delimiter='\t', header=None)
enhancer_df.columns = ['Chromosome', 'Start', 'End'] + ['Extra' + str(i) for i in range(3, enhancer_df.shape[1])]
enhancer_df['Start'] = enhancer_df['Start'].astype(int)
enhancer_df['End'] = enhancer_df['End'].astype(int)

# Create a PyRanges object from enhancer data
enhancer_gr = pr.PyRanges(enhancer_df)

# Directory containing the .bed files
bed_files_dir = '/path/cell_sc_bams/cell_type_1_sc_bams/cell_type_1_merged_bed'

# Process each .bed file in the directory
for bed_file in os.listdir(bed_files_dir):
    if bed_file.endswith('.bed'):
        bed_file_path = os.path.join(bed_files_dir, bed_file)
        try:
            bed_df = pd.read_csv(bed_file_path, delimiter='\t', header=None)
            bed_df.columns = ['Chromosome', 'Start', 'End'] + ['Extra' + str(i) for i in range(3, len(bed_df.columns))]
            bed_df['Start'] = pd.to_numeric(bed_df['Start'], errors='coerce')
            bed_df['End'] = pd.to_numeric(bed_df['End'], errors='coerce')
        except Exception as e:
            print(f"Error reading the BED file {bed_file}: {e}")
            continue

        # Process for overlaps if bed_df is successfully loaded
        if bed_df is not None:
            bed_df.dropna(subset=['Chromosome', 'Start', 'End'], inplace=True)
            bed_gr = pr.PyRanges(bed_df)

            # Find overlaps
            overlaps = enhancer_gr.join(bed_gr)

            # Check if overlaps exist and save to a new file
            if not overlaps.df.empty:
                overlaps_df = overlaps.df  # This will include all columns from both enhancer and bed files
                output_filename = f"{os.path.basename(bed_file_path)[:-4]}_overlaps_enhancer.csv"
                output_filepath = os.path.join(os.path.dirname(bed_file_path), output_filename)
                overlaps_df.to_csv(output_filepath, index=False)
                print(f"Overlaps written to {output_filepath}")
            else:
                print(f"No overlaps found in {bed_file}")
        else:
            print(f"Failed to process BED file {bed_file} due to errors.")