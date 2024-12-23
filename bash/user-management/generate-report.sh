#!/bin/bash

dir=$1

file_count=$(find "$dir" -type f | wc -l)
dir_count=$(find "$dir" -type d | wc -l)
total_size=$(du -sh "$dir" | cut -f1)

echo "Number of files: $file_count" > "$dir/report.txt"
echo "Number of directories: $dir_count" >> "$dir/report.txt"
echo "Total size: $total_size" >> "$dir/report.txt"