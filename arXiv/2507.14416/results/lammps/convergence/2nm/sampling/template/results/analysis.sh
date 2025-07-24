#!/bin/bash

for filename in nvt_prod_*.lammpstrj*
do
(
  basename="${filename%%.lammpstrj*}"
  for sampling in 1 2 8 16
  do
    MDTools RadiusOfGyration --io.trajectory_input "$filename" --io.output "${basename}_${sampling}_rog" --simulation.delta_iteration "${sampling}" --simulation.time_step 0.001 --simulation.atom_mass 55.845 55.845 15.9994
  done
)
done
