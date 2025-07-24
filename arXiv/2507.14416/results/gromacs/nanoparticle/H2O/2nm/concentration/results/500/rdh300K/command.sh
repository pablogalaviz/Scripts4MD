#!/bin/bash
cd /home/galavizp/PycharmProjects/Fe3O4/data/gromacs/nanoparticle_H2O/2nm/results/tesla/run4/H2O_500
MDTools RadialDistributionHistogram --io.trajectory_input md_phonon_300/out.trr --io.coordinate_input md_phonon_300/out.gro --io.output rdh300K --parameters parameters.ini
