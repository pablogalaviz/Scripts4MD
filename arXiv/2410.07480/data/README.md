# Overview of MD systems studied.

Periodic diamond (PD) supercells and nanodiamond (ND) particles of corresponding numbers
of atoms were investigated. The ND5 (5.3 nm) ND particle is the primary particle of interest in this work.

| Name | PD cells | PD size (nm) | PD atoms | ND diameter (nm) | ND atoms | 
|:-----|:--------:|:------------:|:--------:|:----------------:|:--------:|
| D1** |    43    |     1.4      |   512    |       1.8        |   489    |
| D2   |    63    |     2.1      |   1728   |       2.7        |   1755   |
| D3   |    83    |     2.8      |   4096   |       3.5        |   4109   |
| D4   |   103    |     3.6      |   8000   |       4.4        |   8009   |
| D5*  |   123    |     4.3      |  13824   |       5.3        |  13707   |
| D6   |   143    |     5.0      |  21952   |       6.2        |  21849   |
| D7   |   163    |     5.7      |  32768   |       7.1        |  32791   |
| D8   |   203    |     7.1      |  64000   |       8.8        |  64097   |

*Used to create the core-shell (CS) ND

**Multiple used for the ND cluster(s) (Fig. SI1)

# Directory tree
We provide script to for the following configurations.
```
├── D1
│   ├── Periodic_Diamond
│   ├── Spherical_Diamond
│   └── Spherical_Diamond_Cluster
├── D5
│   ├── Core-Shell_Diamond
│   ├── Periodic_Diamond
│   ├── Spherical_Diamond
│   └── Spherical_Diamond_Dirichlet
└── D8
    ├── Periodic_Diamond
    └── Spherical_Diamond
```

# Instructions 
Each directory contains a template with the input scripts for [lammps](https://www.lammps.org).

Make a copy of the template and edit the `pbs.sh` or `slurm.sh` script to match your HPC requirements.