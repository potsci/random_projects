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





# read in the image and determine the parameters for dilton
filepath=Path('/home/mz071159/width_struts/results/50_45_leofor_thresholding')
filepath.joinpath('full_segmentation').mkdir(parents=True,exist_ok=True)
filepath.joinpath('only_eutectics').mkdir(parents=True,exist_ok=True)
filepath.joinpath('primary_mg').mkdir(parents=True,exist_ok=True)
print(list(filepath.glob('**/bnw_conv.png')))
# fp1=filepath.paresn[1]
# croppath1.mkdir(parents=True, exist_ok=True)
for fp in filepath.glob(('**/bnw_conv.png')):
    img=io.imread("/rwthfs/rz/cluster/home/mz071159/width_struts/results/50_45_leofor_thresholding/50_45_3mm_yolo_eps5_leo_3stitched-0_c000_r000/bnw_conv.png")
    label_img = label(invert(img))
    properties=['axis_minor_length']
    props=measure.regionprops_table(label_img,img,properties=properties)
    df=pd.DataFrame(props)
    mean_width=df['axis_minor_length'].mean()
    dil_iter=mean_width/2/3
    dil_iter=int(dil_iter)
    dilation2=scipy.ndimage.binary_dilation(img==0,disk(3),iterations=dil_iter)
    erosion2=scipy.ndimage.binary_dilation(invert(dilation2),disk(4),iterations=dil_iter)
    eutectic_mask=erosion2-invert(img)
    eutectic_mask=eutectic_mask==0
    mg_eut_filtered=morphology.remove_small_objects(eutectic_mask,min_size=400)
    mg_primary=dilation2==0
    total_ms=np.zeros(img.shape)
    total_ms[img==0]=1
    total_ms[mg_eut_filtered]=2
    plt.imsave(fp.parents[1].joinpath('full_segmentation').joinpath(f'{fp.parents[0].stem}_total_ms.png'),total_ms,cmap='viridis')
    plt.imsave(fp.parents[1].joinpath('only_eutectics').joinpath(f'{fp.parents[0].stem}_eutectics.png'),mg_eut_filtered,cmap='viridis')
    plt.imsave(fp.parents[1].joinpath('primary_mg').joinpath(f'{fp.parents[0].stem}_mg_primary.png'),mg_primary,cmap='viridis')    







