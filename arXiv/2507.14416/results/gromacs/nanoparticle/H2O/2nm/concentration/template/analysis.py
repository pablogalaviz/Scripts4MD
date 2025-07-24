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
    parameters['output_files'] = (u'md_phonon_%d/%s_dos'%(temperature,weights), (u'hdf',))
    parameters['projection'] = None
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'md_phonon_%d/out.nc'%(temperature)
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
for temperature in [200, 300]:
    convert("md_phonon",temperature)
    dos(temperature,"b_coherent")
    dos(temperature,"b_incoherent")


