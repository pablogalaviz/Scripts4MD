#!/bin/bash

for DIRECTORY in md_phonon_*; do
  base_name="$(basename -- $DIRECTORY)"
  temperature=$(echo  $base_name | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
  MDTools RadialDistributionHistogram --io.trajectory_input $DIRECTORY/out.trr --io.coordinate_input $DIRECTORY/out.gro --io.output "rdh${temperature}K" --parameters parameters.ini
done