# -*- coding: utf-8 -*-
"""
Created on Mon Jan  9 09:08:07 2023

@author: berners
"""

import hyperspy.api as hs
import hyperspy as hspy

#%%



path="I:\Fib\C2_zubair\\as_cast_e_polish\\ara21-31\DB_Files\lukas\Cole\Mapping\Lsm\\SFB_samples\\C02_as_cast\\Area 21\\fov20230106143339851.ipr"
#%%
s=hs.load(path)
#%%
with  open(path) as f:
   ipr_head= hspy.io_plugins.edax.__get_ipr_header(f,'')
#%%
type(ipr_head)