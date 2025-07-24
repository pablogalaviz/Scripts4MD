#!/bin/bash

for pair1 in 1 2 3; do
  for pair2 in 1 2 3; do
    if [[ "$pair2" -lt "$pair1" ]]; then
      continue
    fi
    output_dir="pair_${pair1}_${pair2}"
    cp -r template $output_dir
    (
      cd $output_dir || exit
      sed -i "/create_atoms A single 0 0 0/ccreate_atoms ${pair1} single 0 0 0" in.lammps
      sed -i "/create_atoms B single 1 0 0/ccreate_atoms ${pair2} single 0 0 0" in.lammps
      ./local_job.sh
    )
  done
done
