#!/bin/bash
cd /home/galavizp/PycharmProjects/DB17405_H2O_nanopore/data/lammps/structure_generation/amorphous_4nm/reaxff/results/setonix/run1/results
MDTools PairDistributionHistogram --io.trajectory_input nvt_equilibration_300K.lammpstrj.gz --io.output pdh_nvt_equilibration_300K --parameters ../parameters.ini
