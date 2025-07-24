#!/bin/bash
cd /home/galavizp/PycharmProjects/Fe3O4/data/lammps/nanoparticle_H2O/2nm/reaxff2022/results/tesla/run5/H2O_100/results
MDTools RadialDistributionHistogram --io.trajectory_input nvt_phonon_300K.lammpstrj --io.output rdh300K --parameters ../parameters.ini
