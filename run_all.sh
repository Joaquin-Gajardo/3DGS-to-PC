#!/bin/bash

input_folder="../Wheat-GS/data/wheat_heads/pipeline1/20240717/plot_461_unscaled_all_attributes"
output_folder="../Wheat-GS/results/3DGS-to-PC/pipeline1/plot461_20250717_1e6points_1stdev_0.1opa_cull0.01_clean"

mkdir -p "$output_folder"

for input_file in "$input_folder"/*.ply; do
    filename=$(basename "$input_file")
    output_file="$output_folder/${filename}"
    python gauss_to_pc.py  \
    --no_render_colours \
    --clean_pointcloud  \
    --input_path "$input_file" \
    --output_path "$output_file" \
    --num_points 1000000 \
    --min_opacity 0.1 \
    --cull_gaussian_sizes 0.01 \
    --std_distance 1.0
done
