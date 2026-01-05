#!/bin/bash
cd /home/galavizp/PycharmProjects/DB17405_H2O_nanopore/data/lammps/structure_generation/amorphous_4nm/vashishta/results/setonix/run1/results
MDTools PairDistributionHistogram --io.trajectory_input npt_cooling_300K.lammpstrj --io.output pdh_npt_cooling_300K --parameters ../parameters.ini
