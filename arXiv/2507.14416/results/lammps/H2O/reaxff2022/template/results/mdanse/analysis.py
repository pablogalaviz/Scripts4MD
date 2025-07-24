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

def dos(runset,weights,temperature):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['atom_transmutation'] = None
    parameters['frames'] = (0, 5000, 1)
    parameters['grouping_level'] = u'atom'
    parameters['instrument_resolution'] = ('ideal', {})
    parameters['interpolation_order'] = u'2nd order'
    parameters['output_files'] = (u'%s_%s_%dK_dos'%(runset,weights,temperature), (u'hdf',))
    parameters['projection'] = None
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'%s_%dK.nc'%(runset,temperature)
    parameters['weights'] = weights

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################

    print("processing dos at %dK"%temperature)
    dos = REGISTRY['job']['dos']()
    dos.run(parameters,status=True)

def rmsd(temperature):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['atom_transmutation'] = None
    parameters['frames'] = (0, 625, 1)
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

def msd(temperature):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['atom_transmutation'] = None
    parameters['frames'] = (0, 625, 1)
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

def rmsf(temperature):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['frames'] = (0, 625, 1)
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

def rog(temperature):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['frames'] = (0, 625, 1)
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

def ecc(temperature):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['center_of_mass'] = None
    parameters['frames'] = (0, 625, 1)
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
for temperature in [200, 300]:
    convert("nvt_phonon",temperature)
#    convert("nvt_phonon_H2O",temperature)
#    convert("nvt_phonon_Fe3O4",temperature)
    dos("nvt_phonon","b_coherent",temperature)
    dos("nvt_phonon","b_incoherent",temperature)
#    dos("nvt_phonon_H2O","b_coherent",temperature)
#    dos("nvt_phonon_H2O","b_incoherent",temperature)
#    dos("nvt_phonon_Fe3O4","b_coherent",temperature)
#    dos("nvt_phonon_Fe3O4","b_incoherent",temperature)

#    convert("nvt_prod",temperature)
#    msd(temperature)
#    rmsd(temperature)
#    rmsf(temperature)
#    rog(temperature)
#    ecc(temperature)

