#!/bin/bash

base_input_folder="../Wheat-GS/data/wheat_heads/pipeline1/20240717"
base_output_folder="../Wheat-GS/results/3DGS-to-PC/pipeline1/grid_search"

#plots=(461 462 463 464 465 466 467)
plots=(461)
min_opacities=(0.1 0.2)
cull_gaussian_sizes=(0.01 0.05)
std_distances=(1.0 2.0)
num_points=100000

for plot in "${plots[@]}"; do
    input_folder="$base_input_folder/plot_${plot}_unscaled_all_attributes"
    for min_opacity in "${min_opacities[@]}"; do
        for cull_gaussian_size in "${cull_gaussian_sizes[@]}"; do
            for std_distance in "${std_distances[@]}"; do
                output_folder="$base_output_folder/1e5points_${std_distance}stdev_${min_opacity}opa_cull${cull_gaussian_size}_preclean_postclean/plot${plot}/"
                mkdir -p "$output_folder"
                for input_file in "$input_folder"/*.ply; do
                    filename=$(basename "$input_file")
                    output_file="$output_folder/${filename}"
                    python gauss_to_pc.py  \
                    --no_render_colours \
                    --preclean_pointcloud  \
                    --clean_pointcloud  \
                    --input_path "$input_file" \
                    --output_path "$output_file" \
                    --num_points $num_points \
                    --min_opacity $min_opacity \
                    --cull_gaussian_sizes $cull_gaussian_size \
                    --std_distance $std_distance
                done
            done
        done
    done
done
