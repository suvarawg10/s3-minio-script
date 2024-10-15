#!/bin/bash

# Check if input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <getit-list>"
    exit 1
fi

input_file="$1"

# Ensure the input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file does not exist: $input_file"
    exit 1
fi

# Read each line from the input file
while IFS=' ' read -r path size; do
    # Remove the filename from the path to keep only the directory path
    dir_path=$(dirname "$path")
    
    # Perform the mirror operation
    echo "Mirroring s3-bucket/getitnow-prod/$dir_path to ecos-bucket/8485-getitnow-prod/$dir_path"
    mc mirror s3-bucket/getitnow-prod/"$dir_path" ecos-bucket/8485-getitnow-prod/"$dir_path"

    # Check if the mirror operation was successful
    if [ $? -eq 0 ]; then
        echo "Successfully mirrored $dir_path"
    else
        echo "Failed to mirror $dir_path"
    fi

done < "$input_file"

