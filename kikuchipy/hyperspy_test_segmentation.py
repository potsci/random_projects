#%matplotlib qt
import hyperspy.api as hs

#import matplotlib.pyplot as plt
import numpy as np
from pathlib import *



import skimage.segmentation as seg
from skimage import filters
from skimage import (
    data, restoration, util
)
from skimage import io
from skimage.filters import threshold_otsu

import matplotlib.pyplot as plt

be=10 # beam energy in kv

element_list=['Mg','Al','Ca','O']
line_list=['Mg_Ka','Al_Ka','Ca_Ka','O_Ka']

file_n=0
#%%
import hyperspy.signal

path=Path("/work/mz071159/edx/50_45_yolo/")
# file="map20220810083556875_0.spd"
# ipr="fov20220810083203210.ipr"
spd=list(path.glob('**/*.spd'))
ipr=list(path.glob('**/*.ipr'))
for file_n in range(0,len(spd)):
    s=[]
    print(spd[file_n])
    s= hs.load(spd[file_n], load_all_spc=True, ipr_fname=ipr[file_n]).as_signal2D(1)
    # spec=hs.load(sopd[])
    # spec

    #%%

    # img_list=list(path.glob('**/*_Img.bmp'))
    img_file=spd[file_n].parent.joinpath(f'{spd[file_n].stem}_Img.bmp')
    img=io.imread(img_file)
    background = restoration.rolling_ball(img)
    img_b_sub=img-background
    plt.imshow(img,cmap='gray')
    #%%
    thresh=threshold_otsu(img_b_sub)
    mask=img_b_sub>thresh
    fig,ax=plt.subplots(1,3,figsize=(10,3))
    ax[0].imshow(img,cmap='gray')
    ax[0].set_title('orig SE image')
    ax[1].imshow(img_b_sub,cmap='gray')
    ax[1].set_title('background corrected')
    ax[2].set_title('masked')
    ax[2].imshow(mask)
    fig.savefig(spd[file_n].parents[1].joinpath(f'{spd[file_n].parent.stem}_{spd[file_n].stem}_comparison_segmentation.png'))

    #%%
    shape_save=s.data.shape
    data_array=s.data
    mask_tiles=np.tile(mask,[shape_save[2],1,1])
    # mask_tiles.shape
    mask_tiles=mask_tiles.transpose(1,2,0)
    data_array_masked=data_array*mask_tiles #mask and inverse mask in next row
    data_array_masked2=data_array*~mask_tiles 
    data_array_masked.shape


    #%%
    #construct the two different signals
    newsig1_inv= hyperspy._signals.eds.EDSSpectrum(data_array_masked)
    newsig1_inv.set_signal_type('EDS_SEM')
    newsig1_inv.original_metadata=s.original_metadata
    newsig1_inv.metadata=s.metadata
    newsig1_inv.axes_manager=s.axes_manager

    # data_array_masked=data_array*~mask_tiles
    # data_array_masked.shape
    newsig2_inv= hyperspy._signals.eds.EDSSpectrum(data_array_masked2)
    newsig2_inv.set_signal_type('EDS_SEM')
    newsig2_inv.original_metadata=s.original_metadata
    newsig2_inv.metadata=s.metadata
    newsig2_inv.axes_manager=s.axes_manager

    print('masking and application succeded...')
    #%%
    # sum above all points to get th sum spectrum of the two regions from the map

    sumsig=np.sum(newsig1_inv.data,axis=(0,1))
    sumsig.shape

    sumsig2=np.sum(newsig2_inv.data,axis=(0,1))
    sumsig2.shape
    #%%
    fig,ax=plt.subplots()
    im=ax.imshow(np.sum(newsig2_inv.data,axis=(2)),cmap='gray')
    fig.colorbar(im)
    fig.savefig((spd[file_n].parents[1].joinpath(f'{spd[file_n].parent.stem}_{spd[file_n].stem}_counts_phase2.png')))

    #%%
    fig,ax=plt.subplots()
    im=ax.imshow(np.sum(newsig1_inv.data,axis=(2)),cmap='gray')
    fig.colorbar(im)
    fig.savefig((spd[file_n].parents[1].joinpath(f'{spd[file_n].parent.stem}_{spd[file_n].stem}_counts_phase1.png')))

    #%%
    matrix=[]
    matrix= hyperspy._signals.eds.EDSSpectrum(sumsig2)
    matrix.set_signal_type('EDS_SEM')
    matrix.original_metadata=s.original_metadata
    matrix.metadata=s.metadata
    matrix.axes_manager[-1].name='Energy'
    matrix.axes_manager['Energy'].units=s.axes_manager['Energy'].units
    matrix.axes_manager['Energy'].scale=s.axes_manager['Energy'].scale
    matrix.axes_manager['Energy'].offset=s.axes_manager['Energy'].offset

    matrix.set_microscope_parameters(beam_energy=10)


    matrix.set_elements(['Mg','Al','Ca','O'])
    # matrix.add_lines()
    matrix.set_lines(['Mg_Ka','Al_Ka','Ca_Ka','O_Ka'])

    #%%
    precip=hyperspy._signals.eds.EDSSpectrum(sumsig)
    precip.set_signal_type('EDS_SEM')
    precip.original_metadata=s.original_metadata
    precip.metadata=s.metadata
    precip.axes_manager[-1].name='Energy'
    precip.axes_manager['Energy'].units=s.axes_manager['Energy'].units
    precip.axes_manager['Energy'].scale=s.axes_manager['Energy'].scale
    precip.axes_manager['Energy'].offset=s.axes_manager['Energy'].offset
    precip.set_microscope_parameters(beam_energy=be)


    precip.set_elements(element_list)
    # matrix.add_lines()
    precip.set_lines(line_list)


# (spd[0].parents[file_n].joinpath(f'{spd[file_n].parent.stem}_{spd[file_n].stem}_comparison_segmentation.png'))
    precip.save((spd[file_n].parents[1].joinpath(f'{spd[file_n].parent.stem}_{spd[file_n].stem}_phase1.msa')),overwrite=True)
    matrix.save((spd[file_n].parents[1].joinpath(f'{spd[file_n].parent.stem}_{spd[file_n].stem}_phase2.msa')),overwrite=True)
    print('saving files')
    #%%