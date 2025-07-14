import pandas as pd
import sys
import os

def process_enhancer_data(file_path):
    # Load the data
    data = pd.read_csv(file_path, low_memory=False)
    
    # Initialize a list to store enhancer summaries
    enhancer_summaries = []

    # Iterate through the dataframe and group contiguous rows with the same Chromosome, Start, and End
    current_enhancer = None
    enhancer_info = {}

    for i, row in data.iterrows():
        chrom, start, end = row['Chromosome'], row['Start'], row['End']
        
        # Check if this row is part of the current enhancer
        if current_enhancer and chrom == current_enhancer['Chromosome'] and start == current_enhancer['Start'] and end == current_enhancer['End']:
            # Update enhancer info
            enhancer_info['GENE_symbols'].update(row[3:6].dropna().tolist())
            if 'Extra7' in row and pd.notna(row['Extra7']):
                enhancer_info['GENE_symbols'].add(row['Extra7'])
            if 'Extra3_b' in row and 'Extra5_b' in row and pd.notna(row['Extra3_b']) and pd.notna(row['Extra5_b']):
                enhancer_info['Transcription_factors'].add((row['Extra3_b'], row['Extra5_b']))
        else:
            # Save the current enhancer info to summaries list if it's not the first row
            if current_enhancer:
                enhancer_summaries.append(enhancer_info)
            
            # Start a new enhancer
            current_enhancer = {'Chromosome': chrom, 'Start': start, 'End': end}
            enhancer_info = {
                'Chromosome': chrom,
                'Start': start,
                'End': end,
                'GENE_symbols': set(row[3:6].dropna().tolist()),
                'Cell_line': row['Extra6'] if 'Extra6' in row else 'Unknown',
                'Distance_to_nearest_gene': row['Extra8'] if 'Extra8' in row else 'Unknown',
                'Transcription_factors': set([(row['Extra3_b'], row['Extra5_b'])]) if 'Extra3_b' in row and 'Extra5_b' in row and pd.notna(row['Extra3_b']) and pd.notna(row['Extra5_b']) else set(),
            }
            if 'Extra7' in row and pd.notna(row['Extra7']):
                enhancer_info['GENE_symbols'].add(row['Extra7'])
    
    # Append the last enhancer
    enhancer_summaries.append(enhancer_info)
    
    # Convert the summaries to a DataFrame
    summary_df = pd.DataFrame(enhancer_summaries)
    
    # Handle non-string values in 'GENE_symbols'
    summary_df['GENE_symbols'] = summary_df['GENE_symbols'].apply(lambda x: ','.join(str(i) for i in x))
    
    # Handle non-string values in 'Transcription_factors'
    summary_df['Transcription_factors'] = summary_df['Transcription_factors'].apply(lambda x: ';'.join([f"{tf}({strand})" for tf, strand in x]))
    
    # Save the summary DataFrame to a new CSV file
    output_file_path = file_path.replace('.csv', '_summary.csv')
    summary_df.to_csv(output_file_path, index=False)

def main():
    # Dummy file path for standalone testing
    file_path = "/path/overlaps_enhancer.csv"
    
    if not os.path.isfile(file_path):
        print(f"Error: File {file_path} does not exist.")
        sys.exit(1)
    
    process_enhancer_data(file_path)

if __name__ == "__main__":
    main()
