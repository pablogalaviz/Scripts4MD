#!/bin/bash
cd /home/galavizp/PycharmProjects/Fe3O4/data/lammps/nanoparticle/2nm/lennard_jones/results/tesla/run1/results
MDTools RadiusOfGyration --io.trajectory_input nvt_prod_200K.lammpstrj --io.output nvt_prod_200K_rog -d --simulation.time_step 0.001 --simulation.atom_mass 55.845 55.845 15.9994
