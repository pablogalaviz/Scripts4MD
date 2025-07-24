#!/bin/bash

for filename in nvt_prod_*.lammpstrj*
do
(
  basename="${filename%%.lammpstrj*}"
  MDTools RadiusOfGyration --io.trajectory_input "$filename" --io.output "${basename}_rog" -d --simulation.time_step 0.001 --simulation.atom_mass 55.845 55.845 15.9994
)
done
