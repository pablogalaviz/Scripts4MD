#!/usr/local/bin/python

########################################################
# This is an automatically generated MDANSE run script #
########################################################

from MDANSE import REGISTRY

def convert(runset,temperature,n_steps=0):
    parameters = {}
    parameters['config_file'] = u'../../initial_structure.data'
    parameters['mass_tolerance'] = 0.001
    parameters['n_steps'] = n_steps
    parameters['output_file'] = (u'%s_%dK' % (runset,temperature), 'netcdf')
    parameters['smart_mass_association'] = True
    parameters['time_step'] = 1.0
    parameters['trajectory_file'] = u'../../%s_%dK.lammpstrj' % (runset,temperature)

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################

    print("converting %s data at %dK" % (runset,temperature))
    lammps = REGISTRY['job']['lammps']()
    lammps.run(parameters, status=True)

def dos(temperature,frames=(0, 10000, 1)):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['atom_transmutation'] = None
    parameters['frames'] = frames
    parameters['grouping_level'] = u'atom'
    parameters['instrument_resolution'] = ('gaussian', {'mu': 0.0, 'sigma': 0.1})
    parameters['interpolation_order'] = u'2nd order'
    parameters['output_files'] = (u'nvt_phonon_%dK_dos'%temperature, (u'hdf',))
    parameters['projection'] = None
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'nvt_phonon_%dK.nc'%temperature
    parameters['weights'] = u'atomic_weight'

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################

    print("processing dos at %dK"%temperature)
    dos = REGISTRY['job']['dos']()
    dos.run(parameters,status=True)

def rmsd(temperature,frames=(0, 10000, 1)):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['atom_transmutation'] = None
    parameters['frames'] = frames
    parameters['grouping_level'] = u'atom'
    parameters['output_files'] = (u'nvt_prod_%dK_rmsd'%temperature, (u'hdf',))
    parameters['reference_frame'] = 0
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'nvt_prod_%dK.nc'%temperature
    parameters['weights'] = u'equal'

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################
    print("processing rmsd at %dK"%temperature)

    rmsd = REGISTRY['job']['rmsd']()
    rmsd.run(parameters,status=True)

def msd(temperature,frames=(0, 10000, 1)):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['atom_transmutation'] = None
    parameters['frames'] = frames
    parameters['grouping_level'] = u'atom'
    parameters['output_files'] = (u'nvt_prod_%dK_msd'%temperature, (u'hdf',))
    parameters['projection'] = None
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'nvt_prod_%dK.nc'%temperature
    parameters['weights'] = u'equal'

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################
    print("processing msd %dK"%temperature)
    msd = REGISTRY['job']['msd']()
    msd.run(parameters,status=True)

def rmsf(temperature,frames=(0, 10000, 1)):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['frames'] = frames
    parameters['grouping_level'] = u'atom'
    parameters['output_files'] = (u'nvt_prod_%dK_rmsf'%temperature, (u'hdf',))
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'nvt_prod_%dK.nc'%temperature

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################
    print("processing rmsf at %dK"%temperature)

    rmsf = REGISTRY['job']['rmsf']()
    rmsf.run(parameters,status=True)

def rog(temperature,frames=(0, 10000, 1)):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['frames'] = frames
    parameters['output_files'] = (u'nvt_prod_%dK_rog'%temperature, (u'hdf',))
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'nvt_prod_%dK.nc'%temperature
    parameters['weights'] = u'equal'

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################
    print("processing rog at %dK"%temperature)

    rog = REGISTRY['job']['rog']()
    rog.run(parameters,status=True)

def ecc(temperature,frames=(0, 10000, 1)):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['center_of_mass'] = None
    parameters['frames'] = frames
    parameters['output_files'] = (u'nvt_prod_%dK_ecc'%temperature,(u'hdf',))
    parameters['trajectory'] = u'nvt_prod_%dK.nc'%temperature
    parameters['weights'] = u'equal'

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################
    print("processing ecc at %dK"%temperature)

    ecc = REGISTRY['job']['ecc']()
    ecc.run(parameters, status=True)

################################################################
# Job parameters                                               #
################################################################
for temperature in [100]:
    convert("nvt_prod",temperature)
    convert("nvt_phonon",temperature,n_steps=5000)
    dos(temperature)
    msd(temperature,frames=(0, 10000, 2))
    rmsd(temperature,frames=(0, 10000, 2))
    rmsf(temperature,frames=(0, 10000, 2))
    rog(temperature,frames=(0, 10000, 2))
    ecc(temperature,frames=(0, 10000, 2))

