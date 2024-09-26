#!/bin/bash

# while logs directory contains too much data, prune the oldest

folder_path="$HOME/.brunt-dotfiles/logs"

max_size_bytes=$(jq -r '.maxSizeBytes' $HOME/.brunt-dotfiles/config/logs.json)
max_number_files=$(jq -r '.maxNumberFiles' $HOME/.brunt-dotfiles/config/logs.json)

while [ "$(ls -A "$folder_path" | wc -l)" -gt "$max_number_files" ] \
    && [ "$(du -s --block-size=1 $folder_path | awk '{print $1}')" -gt "$max_size_bytes" ]; do
    
    first_file="$(ls "$folder_path" | sort | head -n 1)"

    if [ -n "$first_file" ]; then
        rm "$folder_path/$first_file"
    else
        exit 0
    fi
done