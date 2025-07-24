#!/bin/bash
cd /home/galavizp/PycharmProjects/Fe3O4/data/lammps/convergence/2nm/sampling/results/setonix/run2/results
MDTools RadiusOfGyration --io.trajectory_input nvt_prod_100K.lammpstrj.gz --io.output nvt_prod_100K_8_rog --simulation.delta_iteration 8 --simulation.time_step 0.001 --simulation.atom_mass 55.845 55.845 15.9994
