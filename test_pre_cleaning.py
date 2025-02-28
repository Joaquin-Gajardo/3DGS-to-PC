from pathlib import Path
import numpy as np

from mesh_handler import clean_point_cloud
from gauss_dataloader import load_gaussians, save_xyz_to_ply


def main(input_dir, output_dir):

    output_dir.mkdir(parents=True, exist_ok=True)
    input_files = sorted(input_dir.glob("*.ply"))

    log_file = output_dir / "cleaning_log.txt"
    points_removed_per_file = []
    with open(log_file, "w") as log:
        for input_file in input_files:  
            output_path = str(output_dir / f"{input_file.stem}_precleaned.ply")
            xyz, _, _, colours, _ = load_gaussians(str(input_file), max_sh_degree=3)
            cleaned_xyz, _, _ = clean_point_cloud(xyz, colours, None)
            save_xyz_to_ply(cleaned_xyz, output_path)
            
            points_removed = len(xyz) - len(cleaned_xyz)
            points_removed_per_file.append(points_removed)            
            log.write(f"{input_file.name}: {points_removed} points removed\n")

    average_points_removed = sum(points_removed_per_file) / len(input_files)
    print(f"Total points removed: {sum(points_removed_per_file)}")
    print(f"Average points removed per file: {average_points_removed}")


if __name__ == "__main__":
    
    input_path = Path("../Wheat-GS/data/wheat_heads/pipeline1/20240717/plot_461_unscaled_all_attributes")
    output_path = Path("../Wheat-GS/results/3DGS-to-PC/pipeline1/pre_cleaning")

    main(input_path, output_path)