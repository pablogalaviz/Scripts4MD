#!/bin/bash
cd /mnt/c/Users/galavizp/PycharmProjects/DB17405_H2O_nanopore/data/lammps/pore_4nm_H2O/reaxff/results/tesla/run2/wm_360
MDTools AxialDistributionHistogram --io.trajectory_input results/nvt_prod_300K.lammpstrj.gz --io.output results/rdf_300K -p parameters.ini
