import matplotlib.pyplot as plt
import math
import numpy as np
from pathlib import *
from skimage.measure import euler_number, label

from PIL import Image
Image.MAX_IMAGE_PIXELS = 10000000000

fp=Path('/home/mz071159/width_struts/results/stichings')
png_list=list(fp.glob('**/*.png'))
print(png_list)
# png_list

import pandas as pd
crop=list(fp.glob('*.txt'))[0]
df=pd.read_csv(crop,sep=';')

with open('euler_numbers.txt','w') as f:
    f.write('Image_Name;type;Euler_Number_4;Holes_4;Objects_4;Euler_Number_8;Holes_8;Objects_8 \n')

for png in png_list:

    img=Image.open(png)
    I=np.asarray(img)
    if I.ndim>2:
        I=I[:,:,0]
    for key in df['name'].values:
        if key in png.stem:
            print(key)
            width=df[df['name']==key].width.values[0]
            height=df[df['name']==key].height.values[0]
            label=df[df['name']==key].label.values[0]
            break
    I=I[:width,:height]
    print(I.shape)
    if key != 'only_eutectics':
        I_bin=I[:,:]<=100
   

    # I_bin=I[:,:]>=150 # this will fail for the full segmentation

    e4 = euler_number(I_bin, connectivity=1)
    object_nb_4 = label(I_bin, connectivity=1).max()
    holes_nb_4 = object_nb_4 - e4

    e8 = euler_number(I_bin, connectivity=2)
    object_nb_8 = label(I_bin, connectivity=2).max()
    holes_nb_8 = object_nb_8 - e8

    with open('euler_numbers.txt','a') as f:
        f.write(f'{label};{png.parent.stem};{e4};{holes_nb_4};{object_nb_4};{e8};{holes_nb_8};{object_nb_8} \n')