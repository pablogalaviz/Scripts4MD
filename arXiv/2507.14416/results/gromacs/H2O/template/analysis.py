#!/usr/local/bin/python

########################################################
# This is an automatically generated MDANSE run script #
########################################################

from MDANSE import REGISTRY

def convert(runset,temperature):
    parameters = {}
    parameters['fold'] = True
    parameters['output_file'] = (u'%s_%d/out' % (runset, temperature), 'netcdf')
    parameters['pdb_file'] = u'%s_%d/out.pdb' % (runset, temperature)
    parameters['xtc_file'] = u'%s_%d/out.trr' % (runset, temperature)

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################
    print("converting %s data at %dK" % (runset,temperature))

    gromacs = REGISTRY['job']['gromacs']()
    gromacs.run(parameters, status=True)


def dos(temperature,weights):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['atom_transmutation'] = None
    parameters['frames'] = (0, 5000, 1)
    parameters['grouping_level'] = u'atom'
    parameters['instrument_resolution'] = ('ideal', {})
    parameters['interpolation_order'] = u'2nd order'
    parameters['output_files'] = (u'md_prod_%d/%s_dos'%(temperature,weights), (u'hdf',))
    parameters['projection'] = None
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'md_prod_%d/out.nc'%(temperature)
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
    parameters['output_files'] = (u'md_prod_%d/rmsd'%temperature, (u'hdf',))
    parameters['reference_frame'] = 0
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'md_prod_%d/out.nc'%temperature
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
    parameters['output_files'] = (u'md_prod_%d/msd'%temperature, (u'hdf',))
    parameters['projection'] = None
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'md_prod_%d/out.nc'%temperature
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
    parameters['output_files'] = (u'md_prod_%d/rmsf'%temperature, (u'hdf',))
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'md_prod_%d/out.nc'%temperature

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
    parameters['output_files'] = (u'md_prod_%d/rog'%temperature, (u'hdf',))
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'md_prod_%d/out.nc'%temperature
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
    parameters['output_files'] = (u'md_prod_%d/ecc'%temperature,(u'hdf',))
    parameters['trajectory'] = u'md_prod_%d/out.nc'%temperature
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
for temperature in [250, 300]:
    convert("md_prod",temperature)
    dos(temperature,"b_coherent")
    dos(temperature,"b_incoherent")

