#!/usr/local/bin/python

########################################################
# This is an automatically generated MDANSE run script #
########################################################

from MDANSE import REGISTRY

def convert(temperature,system):
    parameters = {}
    parameters['config_file'] = u'../initial_structure.data'
    parameters['mass_tolerance'] = 0.001
    parameters['n_steps'] = 0
    parameters['output_file'] = (u'%s/nvt_prod_%dK' % (system,temperature), 'netcdf')
    parameters['smart_mass_association'] = True
    parameters['time_step'] = 1.0
    if system == "H2O":
        file = 'nvt_prod_%dK_H2O.lammpstrj' % temperature
    elif system == "SiO2":
        file = 'nvt_prod_%dK_SiO2.lammpstrj' % temperature
    else:
        file = 'nvt_prod_%dK.lammpstrj' % temperature
    parameters['trajectory_file'] = u'../' + file

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################

    print("converting %s data at %dK" % (system,temperature))
    lammps = REGISTRY['job']['lammps']()
    lammps.run(parameters, status=True)

def dos(temperature,weights,system):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['atom_transmutation'] = None
    parameters['frames'] = (0, 5000, 1)
    parameters['grouping_level'] = u'atom'
    parameters['instrument_resolution'] = ('ideal', {})
    parameters['interpolation_order'] = u'2nd order'
    parameters['output_files'] = (u'%s/%s_%dK_dos'%(system, weights,temperature), (u'hdf',))
    parameters['projection'] = None
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'%s/nvt_prod_%dK.nc'%(system,temperature)
    parameters['weights'] = weights

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################

    print("processing %s %s dos at %dK"%(weights,system,temperature))
    dos = REGISTRY['job']['dos']()
    dos.run(parameters,status=True)

################################################################
# Job parameters                                               #
################################################################
for temperature in [100, 200, 300]:
    for system in ["H2O","Total","SiO2"]:
        convert(temperature,system)
        dos(temperature,"b_coherent",system)
        dos(temperature,"b_incoherent",system)


