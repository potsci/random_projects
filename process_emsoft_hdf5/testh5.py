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

f= h5py.File(file)
#%%
#print(str(file.parts[-1])[:-3])
#%%



#%%
print(list(f.keys()))
gr=f['EMData']
print(gr.keys())
s_gr=gr['EBSDmaster']
print(s_gr.keys())
data=s_gr['masterSPNH']
keVs=s_gr['EkeVs']
#print(keVs[12])
#%%
import matplotlib.pyplot as plt

#%%
#i=len(keVs)
plt.imshow(data[2,:,:])
plt.axis('off')
#%%
for i in range(data.shape[0]):
    plt.imsave(f"{str(file)[:-3]}_{keVs[i]}keV.png",data[i,:,:],cmap='gray')

#%%
# =============================================================================
# head=f['EMheader']
# print(head.keys())
# head_EBSD=head['EBSDmaster']
# print(head_EBSD.keys())
# 
# #%%
# print(data.shape[0])
# 
# #%% Image comparison
# img1= Path(askopenfilename(initialdir='I:/EMSoft_files/from_linux', title='´Select the first image for comparison'))
# img2= Path(askopenfilename(initialdir='I:/EMSoft_files/from_linux', title='´Select the second image for comparison'))
# #%%
# cv_img1=cv2.imread(str(img1))
# cv_img2=cv2.imread(str(img2))
# 
# #%%
# 
# diff_img=cv_img1-cv_img2
# 
# #%%
# plt.imshow(diff_img)
# plt.imsave(f"{str(file)[:-3]}_{18}keV_diff_plot.png",diff_img)
# =============================================================================
header=f['EMheader']
print(header.keys())
headermaster=header['EBSDmaster']
print(headermaster.keys())
dur=headermaster()
#%%
def print_attrs(name, obj):
    print( name)
    for key, val in obj.attrs.items():
        print( "    %s: %s" % (key, val))

f.visititems(print_attrs)