import os
import shutil
import logging

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Base directory containing all the subdirectories to process
base_parent_path = "/path/cell_sc_bams"

# List of target subdirectories to process
subdirectories = [
    "cell_type_1", "cell_type_2", "cell_type_3", "cell_type_4", "cell_type_5", "cell_type_6"
]

for subdir in subdirectories:
    # Define the full path for each target subdirectory
    base_path = os.path.join(base_parent_path, f"{subdir}_sc_bams", f"{subdir}_sorted_bams", "ATACorrect")
    destination_path = os.path.join(base_parent_path, f"{subdir}_sc_bams")

    # Ensure the destination directory exists
    os.makedirs(destination_path, exist_ok=True)
    logging.info(f"Checked/created destination directory: {destination_path}")

    try:
        # Iterate only through immediate subdirectories of the base_path
        for entry in os.listdir(base_path):
            full_path = os.path.join(base_path, entry)
            if os.path.isdir(full_path) and '_BinDetect' in entry:
                file_path = os.path.join(full_path, 'bindetect_results.txt')
                if os.path.exists(file_path):
                    # Construct the new file name and its full path
                    new_file_name = f"{entry}_bindetect_results.txt"
                    new_file_path = os.path.join(full_path, new_file_name)

                    # Rename the file
                    os.rename(file_path, new_file_path)
                    logging.info(f"Renamed '{file_path}' to '{new_file_path}'")

                    # Copy the renamed file to the destination directory
                    shutil.copy(new_file_path, destination_path)
                    logging.info(f"Copied '{new_file_name}' to '{destination_path}'")
                else:
                    logging.warning(f"File 'bindetect_results.txt' not found in '{full_path}'")
            else:
                logging.debug(f"Skipped non-target directory: {full_path}")
    except Exception as e:
        logging.error(f"Error encountered in directory '{base_path}': {e}")
