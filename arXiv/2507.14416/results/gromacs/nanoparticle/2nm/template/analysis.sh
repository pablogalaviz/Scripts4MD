#!/bin/bash

for path in md_prod_*
do
(
  cd $path || exit

  (echo 0; echo 0) | gmx gyrate -f out.trr -s input.tpr
  MDTools RadiusOfGyration --io.trajectory_input out.trr --io.coordinate_input out.gro --io.output rog -d --simulation.time_step 0.001 --simulation.atom_mass 55.845 15.9994
)
done
