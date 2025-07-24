#!/bin/bash
cd /home/galavizp/PycharmProjects/Fe3O4/data/gromacs/nanoparticle/8nm/results/tesla/run2/md_prod_200
MDTools RadiusOfGyration --io.trajectory_input out.trr --io.coordinate_input out.gro --io.output rog -d --simulation.time_step 0.001 --simulation.atom_mass 55.845 15.9994
