import os
import matplotlib as mpl
if os.environ.get('DISPLAY','') == '':
    print('no display found. Using non-interactive Agg backend')
    mpl.use('Agg')
import matplotlib.pyplot as pltd
import h5py
#import tkinter

#matplotlib.use('Agg')
#_tkinter.TclEr>ror: no display name and no $DISPLAY environment variable
from tkinter.filedialog import askopenfilename
from pathlib import *
#import re
import cv2 as cv2
import numpy as np
import os.path as path
import pandas as pd
#%%
file_name="Nb6_Co7_MC_20_kv_500px.h5"
file_name=Path(file_name)
f= h5py.File(file_name)
#%%

df=pd.DataFrame()
#%%
def print_attrs(name, obj):
    #df=pd.DataFrame()
    print( name)
    #i=0
    namelist=[]
    for key, val in obj.attrs.items():
     #   i=i+1
        print( "    %s: %s" % (key, val))
     #   df["i"]=i
        #keylist=keylist.append(key)
    namelist=namelist.append(name)
    return(name)

keylist=f.visititems(print_attrs)
#%%
key
# %%


#def read_emmaster_meta(f)
EMheader=f['EMheader']
master_head=EMheader['EBSDmaster']
mc_head=EMheader['MCOpenCL']

#%%
#master_head[keys]
df=pd.DataFrame()
for key in master_head.keys():
    print(master_head[key])
    df[(f"master_{key}")]=master_head[key]
for key in mc_head.keys():
    print(mc_head[key])
    df[(f"mc_{key}")]=master_head[key]
# %%
