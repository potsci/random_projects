#%%
# Exchange inline for notebook or qt5 (from pyqt) for interactive plotting
%matplotlib inline

import os
from pathlib import Path
import tempfile

import dask.array as da
import imageio.v3 as iio
import numpy as np
import matplotlib.pyplot as plt

import hyperspy.api as hs
import kikuchipy as kp




# %%
