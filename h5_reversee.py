# -*- coding: utf-8 -*-
"""
Created on Thu Jan  5 16:21:38 2023

@author: berners
"""

import h5py
import tkinter
from tkinter.filedialog import askopenfilename
from pathlib import *
#import re
import cv2 as cv2
import numpy as np
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
gr=f['Scan 1']
#%%
print(gr.keys())
#%%
s_gr=gr['EBSD']

print(s_gr.keys())
#data=s_gr['EBSDPatterns']
#%%
data=s_gr['Data']
print(data.keys())
#%%eulang=s_gr['EulerAngles']
#print(eulang[:]*360/(2*np.pi))
#print(keVs[12])
#%%s
s_s_gr=data['Pattern']
#print(gr.keys())
print(s_s_gr)
plt.imshow(s_s_gr[6,:,:])