import matplotlib.pyplot as plt
import numpy as np
import scipy
from pathlib import *
import pandas as pd

from skimage import util 
from skimage import io
from skimage import morphology
from skimage.util import invert
from skimage.measure import label, regionprops, regionprops_table
from skimage.morphology import (erosion, dilation, disk)
from skimage import measure

def rle(inarray):
        """ run length encoding. Partial credit to R rle function. 
            Multi datatype arrays catered for including non Numpy
            returns: tuple (runlengths, startpositions, values) """
        ia = np.asarray(inarray)                # force numpy
        n = len(ia)
        if n == 0: 
            return (None, None, None)
        else:
            y = ia[1:] != ia[:-1]               # pairwise unequal (string safe)
            i = np.append(np.where(y), n - 1)   # must include last element posi
            z = np.diff(np.append(-1, i))       # run lengths
            p = np.cumsum(np.append(0, z))[:-1] # positions
            return(z, p, ia[i])


# read in the image and determine the parameters for dilton
filepath=Path('/home/mz071159/width_struts/results/50_45_leofor_thresholding')
filepath.joinpath('original_segmentation').mkdir(parents=True,exist_ok=True)
filepath.joinpath('full_segmentation').mkdir(parents=True,exist_ok=True)
filepath.joinpath('only_eutectics').mkdir(parents=True,exist_ok=True)
filepath.joinpath('primary_mg').mkdir(parents=True,exist_ok=True)
filepath.joinpath('dendrites').mkdir(parents=True,exist_ok=True)
print(list(filepath.glob('**/bnw_conv.png')))
# fp1=filepath.paresn[1]
# croppath1.mkdir(parents=True, exist_ok=True)
for fp in filepath.glob(('**/bnw_conv.png')):
    img=io.imread(fp)
    label_img = label(invert(img))
    properties=['axis_minor_length','area_convex']
    props=measure.regionprops_table(label_img,img,properties=properties)
    df=pd.DataFrame(props)
    mean_width=df.loc[(df['area_convex']>5),'axis_minor_length'].mean()
    dil_iter=(mean_width/6)*1.8
    dil_iter=int(dil_iter)
    dilation2=scipy.ndimage.binary_dilation(img==0,disk(3),iterations=dil_iter)
    erosion2=scipy.ndimage.binary_dilation(invert(dilation2),disk(3),iterations=dil_iter+1)
    eutectic_mask=erosion2-invert(img)
    eutectic_mask=eutectic_mask==0
    mg_eut_filtered=morphology.remove_small_objects(eutectic_mask,min_size=400)
    mg_primary=dilation2==0
    total_ms=np.zeros(img.shape)
    total_ms[img==0]=1
    total_ms[mg_eut_filtered]=2
    
    ## save images
    plt.imsave(fp.parents[1].joinpath('original_segmentation').joinpath(f'{fp.parents[0].stem}_segmented.png'),img,cmap='viridis')
    plt.imsave(fp.parents[1].joinpath('full_segmentation').joinpath(f'{fp.parents[0].stem}_total_ms.png'),total_ms,cmap='viridis')
    plt.imsave(fp.parents[1].joinpath('only_eutectics').joinpath(f'{fp.parents[0].stem}_eutectics.png'),mg_eut_filtered,cmap='viridis')
    plt.imsave(fp.parents[1].joinpath('primary_mg').joinpath(f'{fp.parents[0].stem}_mg_primary.png'),total_ms==0,cmap='viridis')    
    plt.imsave(fp.parents[1].joinpath('dendrites').joinpath(f'{fp.parents[0].stem}_dendrites.png'),mg_primary,cmap='viridis')
    
    ## get some additional parameters (widht of struts and phase fraction)
    l_width=[]  
    l_pos=[]    
    l_value=[]
    ##x
    aspect=total_ms.shape[0]/total_ms.shape[1]
    if aspect >=1:
    step_x=math.floor(max((4000,2000))/10)
    step_y=math.floor(step_x/aspect)
    n_x=10
    n_y=math.floor(n_x/aspect)
    else:
        step_y=math.floor(max((4000,2000))/10)
        step_x=math.floor(step_x/aspect)
        n_y=10
        n_x=math.floor(n_y/aspect)
    

    for i in range(0,nx):
        [width,pos,value]=rle(total_ms[step_x*i,:])
        l_width.append(width)
        l_pos.append(pos)
        l_value.append(value)
    ##y
    for i in range(0,n_y):
        [width,pos,value]=rle(total_ms[:,step_y*i])
        l_width.append(width)
        l_pos.append(pos)
        l_value.append(value)
    
    np.savetxt(fp.parents[1].joinpath('full_segmentation').joinpath(f'{fp.parents[0].stem}_total_ms.csv'),np.transpose([np.concatenate(l_width),np.concatenate(l_pos),np.concatenate(l_value)]),delimiter=';',header='widths;pos;value;',comments='')

    frac_laves=np.count_nonzero(total_ms==1)/(img.shape[0]*img.shape[1])
    frac_mg=np.count_nonzero(total_ms==0)/(img.shape[0]*img.shape[1])
    frac_mg_eut=np.count_nonzero(total_ms==2)/(img.shape[0]*img.shape[1])
    np.savetxt(fp.parents[1].joinpath('full_segmentation').joinpath(f'{fp.parents[0].stem}_phase_fraction.csv'),[frac_laves,frac_mg,frac_mg_eut],delimiter=';',header='frac_laves;frac_mg;frac_mg_eut',comments='')



