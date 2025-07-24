#!/bin/bash
cd /home/galavizp/PycharmProjects/Fe3O4/data/lammps/convergence/2nm/timestep/results/setonix/run5/dt_0.002/results
MDTools RadiusOfGyration --io.trajectory_input nvt_prod_100K.lammpstrj --io.output nvt_prod_100K_rog -d --simulation.time_step 0.002 --simulation.atom_mass 55.845 55.845 15.9994
