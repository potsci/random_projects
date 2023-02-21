# -*- coding: utf-8 -*-
"""
Created on Fri Oct 21 15:21:05 2022

@author: lukas
"""
import tkinter
from tkinter.filedialog import askopenfilename
import CifFile #https://pypi.org/project/PyCifRW/4.3/
cifPath=askopenfilename()
cF= CifFile.ReadCif(cifPath)

#%%
block=cF.first_block()
#%%
order=block.GetItemOrder()
#%%
lp=block.GetLoop('_atom_site_label')
print(lp[0])
#%%
var_all=block.get('_chemical_name_common')
#%%
bl_order=cF.block_input_order

#%%
print(block.items())
#%%
with open(f'{block.get('_chemical_name_common')}.txt')

#%%
group_number_ls=['_space_group_IT_number','_symmetry_Int_Tables_number']
for key in group_number_ls:
    if block.get(key) !=None:
        group_number=int(block.get(key))
        print(group_number)
        break

#%%pay attention that EMsoft uses a different order then the official numbers
#change this for a newer python version
if 0<group_number<=2:
    symmetry=7
elif 3<=group_number<=15:
    symmetry=6
elif 16<=group_number<=74:
    symmetry=4
elif 75<=group_number<=142:
    symmetry=3
elif 143<=group_number<=167:
    symmetry=5
elif 168<=group_number<=194:
    symmetry=4
elif 195<=group_number<=230:
    symmetry=1
print(symmetry)
#%%

a=block.get('_cell_length_a')
b=block.get('_cell_length_b')
c=block.get('_cell_length_c')
alpha=block.get('_cell_angle_alpha')
beta=block.get('_cell_angle_beta')
gamma=block.get('_cell_angle_gamma')

if block.get('_chemical_name_common') is not None:
    chem_name=block.get('_chemical_name_common')
elif  block.get('_chemical_formula_sum'):
    chem_name=block.get('_chemical_formula_sum')

with open(f'{chem_name}.txt','w') as f:
    #adapt here that the crystall symetry etc is included
    f.write(f'{symmetry}\n')
    f.write(f'{a}\n')
    f.write(f'{b}\n') #include regex check here
    f.write(f'{c}\n')
    f.write(f'{alpha}\n')
    f.write(f'{beta}\n')
    f.write(f'{gamma}\n')
    f.write('1 \n')
    
    


#%%
print('7 \n 7')