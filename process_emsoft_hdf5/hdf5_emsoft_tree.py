import os
import matplotlib as mpl
if os.environ.get('DISPLAY','') == '':
    print('no display found. Using non-interactive Agg backend')
    mpl.use('Agg')
import matplotlib.pyplot as pltd
import h5py
#import tkinter

#matplotlib.use('Agg')
#_tkinter.TclError: no display name and no $DISPLAY environment variable
from tkinter.filedialog import askopenfilename
from pathlib import *
#import re
import cv2 as cv2
import numpy as np
import os.path as path
#%%
file_name="Nb6_Co7_MC_20_kv_500px.h5"
file_name=Path(file_name)
f= h5py.File(file_name)
#%%

def print_attrs(name, obj):
    print name
    for key, val in obj.attrs.iteritems():
        print "    %s: %s" % (key, val)

f = h5py.File('foo.hdf5','r')
f.visititems(print_attrs)