#!/bin/bash
cd /mnt/c/Users/galavizp/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O/results/tesla/run1/wm_360
MDTools AxialDistributionHistogram --io.trajectory_input md_prod_200/out.trr --io.coordinate_input md_prod_200/out.gro --io.output analysis/rdf_200K -p parameters.ini
