import os
import matplotlib as mpl
if os.environ.get('DISPLAY', '') == '':
    print('no display found. Using non-interactive Agg backend')
    mpl.use('Agg')
import matplotlib.pyplot as pltd
import h5py
# import tkinter

# matplotlib.use('Agg')
# _tkinter.TclEr>ror: no display name and no $DISPLAY environment variable
from tkinter.filedialog import askopenfilename
from pathlib import *
# import re
import cv2 as cv2
import numpy as np
import os.path as path
import pandas as pd
# %%

# file_name="Nb6_Co7_MC_20_kv_500px.h5"
# file_name=Path(file_name)
# f= h5py.File(file_name)
# %%
dirname = os.path.dirname(__file__)
file_name = 'hdf5/'
file_name = os.path.join(dirname, file_name)
file_name = Path(file_name)
paths = list(file_name.glob('*'))
dfs = pd.DataFrame()
i = 0
for path in paths:
    print(i)
    i = i+1
    f = h5py.File(path)
    df = pd.DataFrame()
    
    EMheader = f['EMheader']
    if 'EBSDmaster' in EMheader.keys():
        master_head = EMheader['EBSDmaster']
        for key in master_head.keys():
            df[(f"master_{key}")] = master_head[key]

    if 'MCOpenCL' in EMheader.keys():
        mc_head = EMheader['MCOpenCL']
        for key in mc_head.keys():
            df[(f"mc_{key}")] = mc_head[key]

    NMLpars = f['NMLparameters']
    if 'EBSDMasterNameList' in NMLpars.keys():
        nml_master = NMLpars['EBSDMasterNameList']
        for key in nml_master.keys():
            df[(f"nml_master_{key}")] = nml_master[key]

    if 'MCCLNameList' in NMLpars.keys():
        nml_mc = NMLpars['MCCLNameList']
        for key in nml_mc.keys():
            df[(f"nml_mc_{key}")] = nml_mc[key]

    dfs = pd.concat([dfs, df])
# %%
#pd.concat(df)
