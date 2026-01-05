#!/usr/local/bin/python

########################################################
# This is an automatically generated MDANSE run script #
########################################################

from MDANSE import REGISTRY

def convert(runset,temperature):
    parameters = {}
    parameters['config_file'] = u'../initial_structure.data'
    parameters['mass_tolerance'] = 0.001
    parameters['n_steps'] = 0
    parameters['output_file'] = (u'%s_%dK' % (runset,temperature), 'netcdf')
    parameters['smart_mass_association'] = True
    parameters['time_step'] = 1.0
    parameters['trajectory_file'] = u'../%s_%dK.lammpstrj' % (runset,temperature)

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################

    print("converting %s data at %dK" % (runset,temperature))
    lammps = REGISTRY['job']['lammps']()
    lammps.run(parameters, status=True)

def dos(temperature,weights):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['atom_transmutation'] = None
    parameters['frames'] = (0, 5000, 1)
    parameters['grouping_level'] = u'atom'
    parameters['instrument_resolution'] = ('ideal', {})
    parameters['interpolation_order'] = u'2nd order'
    parameters['output_files'] = (u'%s_%dK_dos'%(weights,temperature), (u'hdf',))
    parameters['projection'] = None
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'nvt_prod_%dK.nc'%temperature
    parameters['weights'] = weights

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################

    print("processing dos at %dK"%temperature)
    dos = REGISTRY['job']['dos']()
    dos.run(parameters,status=True)

################################################################
# Job parameters                                               #
################################################################
for temperature in [100, 200, 300]:
    convert("nvt_prod",temperature)
    dos(temperature,"b_coherent")
    dos(temperature,"b_incoherent")


