import os
import pandas as pd

# Define the root directory containing all the *_sc_bams folders
root_dir = '/cell_sc_bams'

def is_chromosome_standard(chromosome_name):
    """Check if the chromosome name follows the standard naming convention."""
    # Adjust this list to include only the standard chromosomes you want to keep
    standard_chromosomes = [f"chr{i}" for i in range(1, 23)] + ["chrX", "chrY"]
    return chromosome_name in standard_chromosomes

def process_narrowPeak_file(file_path):
    """Process a single .narrowPeak file to remove non-standard chromosome rows."""
    try:
        # Load the .narrowPeak file without headers
        df = pd.read_csv(file_path, sep='\t', header=None)
        # Filter the DataFrame
        df_filtered = df[df[0].apply(is_chromosome_standard)]
        # Overwrite the original file with the filtered DataFrame
        df_filtered.to_csv(file_path, sep='\t', header=None, index=False)
        print(f"Processed and saved: {file_path}")
    except Exception as e:
        print(f"Error processing file {file_path}: {e}")

def find_and_process_files(root_dir):
    """Find and process all .narrowPeak files under the specified root directory."""
    for subdir, _, files in os.walk(root_dir):
        if 'Genrich_Output' in subdir and subdir.endswith('Genrich_Output'):
            for file in files:
                if file.endswith('_atacseq_sorted_n.narrowPeak'):
                    file_path = os.path.join(subdir, file)
                    process_narrowPeak_file(file_path)

# Execute the processing function
find_and_process_files(root_dir)

print("Processing completed.")