# -*- coding: utf-8 -*-
"""
Created on Mon Oct 24 15:36:20 2022

@author: berners
"""

import h5py
import tkinter
from tkinter.filedialog import askopenfilename
from pathlib import *
#import re
import cv2 as cv2
#%%

file = Path(askopenfilename(initialdir='I:/EMSoft_files/from_linux', title='Select the file with the EMsoft Masterpattern ouput'))
#paths=list(file.parent.glob('**/pano*.tif'))
#os.mkdir(file.parent / 'normalised')
#%%
f= h5py.File(file)
#%%
#print(str(file.parts[-1])[:-3])
#%%



#%%
print(list(f.keys()))
gr=f['EMData']
print(gr.keys())
s_gr=gr['EBSD']
print(s_gr.keys())
data=s_gr['EBSDPatterns']
eulang=s_gr['EulerAngles']
print(eulang[:])
#print(keVs[12])
#%%
import matplotlib.pyplot as plt

#%%
#i=len(keVs)
plt.imshow(data[2,:,:],origin='lower',cmap='gray')

#plt.axis('off')
#plt.imsave(f"{str(file)[:-3]}_{keVs[i]}keV.png",data[2,:,:],cmap='gray')
#%%
for i in range(data.shape[0]):
    plt.imsave(f"{str(file)[:-3]}_{i}.png",data[i,:,:],cmap='gray',origin='lower')
#    plt.gca().invert_yaxis()
#%%
head=f['EMheader']
print(head.keys())
head_EBSD=head['EBSDmaster']
print(head_EBSD.keys())

#%%
print(data.shape[0])

#%% Image comparison
img1= Path(askopenfilename(initialdir='I:/EMSoft_files/from_linux', title='´Select the first image for comparison'))
img2= Path(askopenfilename(initialdir='I:/EMSoft_files/from_linux', title='´Select the second image for comparison'))
#%%
cv_img1=cv2.imread(str(img1))
cv_img2=cv2.imread(str(img2))

#%%

diff_img=cv_img1-cv_img2

#%%
plt.imshow(diff_img)
plt.imsave(f"{str(file)[:-3]}_{18}keV_diff_plot.png",diff_img)