#!/bin/bash
cd /home/galavizp/PycharmProjects/Fe3O4/data/lammps/convergence/2nm/simulation_time/results/setonix/run2/st_15000/results
MDTools RadiusOfGyration --io.trajectory_input nvt_prod_100K.lammpstrj --io.output nvt_prod_100K_rog -d --simulation.time_step 0.001 --simulation.atom_mass 55.845 55.845 15.9994
