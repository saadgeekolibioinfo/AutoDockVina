#!/bin/bash

# Prompt for ligand file
read -p "Enter the ligand file (e.g., ligand.text): " ligfile

# Check if the file can be opened
if [[ ! -f "$ligfile" ]]; then
    echo "Cannot open file: $ligfile"
    exit 1
fi

# Read the file into an array
mapfile -t arr_file < "$ligfile"

# Process each ligand
for ligand in "${arr_file[@]}"; do
    # Remove any trailing newline characters
    ligand=$(echo "$ligand" | tr -d '\n')

    # Check if ligand file exists
    if [[ ! -f "$ligand" ]]; then
        echo "Ligand file does not exist: $ligand"
        continue
    fi

    echo "Processing ligand: $ligand"

    # Extract the name for logging
    name=$(basename "$ligand" | cut -d. -f1)

    # Define output file name
    output_file="${name}_output.pdbqt"

    # Check if output file already exists
    if [[ -f "$output_file" ]]; then
        echo "Output file already exists: $output_file"
        continue
    fi

    # Execute the Vina command
    vina --config config.txt --ligand "$ligand" --out "$output_file"
done
