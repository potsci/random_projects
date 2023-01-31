# -*- coding: utf-8 -*-
"""
Created on Thu Jan 12 12:49:29 2023

@author: berners
"""



import h5py
import tkinter
from tkinter.filedialog import askopenfilename
from pathlib import *
#import re
import cv2 as cv2
import numpy as np


file = Path(askopenfilename(initialdir='I:/EMSoft_files/from_linux', title='Select the file with the EMsoft Masterpattern ouput'))
#paths=list(file.parent.glob('**/pano*.tif'))
#os.mkdir(file.parent / 'normalised')
#%%
f= h5py.File(file)

head=f['EMheader']
print(head.keys())
head_EBSD=head['EBSDmaster']
print(head_EBSD.keys())

#%%
print(data.shape[0])



#%%


















#%%

diff_img=cv_img1-cv_img2

#%%
plt.imshow(diff_img)
plt.imsave(f"{str(file)[:-3]}_{18}keV_diff_plot.png",diff_img)
#%%
print(f['NMLparameters']['EBSDNameList']['xpc'])
xpc=f['NMLparameters']['EBSDNameList']['xpc']
ypc=f['NMLparameters']['EBSDNameList']['ypc'][1]




#%% Image comparison
img1= Path(askopenfilename(initialdir='I:/EMSoft_files/from_linux', title='´Select the first image for comparison'))
img2= Path(askopenfilename(initialdir='I:/EMSoft_files/from_linux', title='´Select the second image for comparison'))
#%%
cv_img1=cv2.imread(str(img1))
cv_img2=cv2.imread(str(img2))