#%%

from PIL import Image 
Image.MAX_IMAGE_PIXELS = None
from pathlib import *
#%%
path=Path('/rwthfs/rz/cluster/work/mz071159/quasi-in-situ/50_45_leo/head/')

print(list(path.glob('**/*')))
#%%
height=4000
width=4000   
i=0
j=0
imsize=[]
croppath1=path.joinpath('crop')
croppath1.mkdir(parents=True, exist_ok=True)
# croppath=path.joinpath('crop')
# croppath.mkdir(parents=True, exist_ok=True)
for imgpath in list(path.glob('**/*.png')):
    i=0
    j=0
    # imgpath.parents[2]
    # croppath=croppath1.joinpath(imgpath.parent.stem)
    # croppath.mkdir(parents=True, exist_ok=True)
    img = Image.open(str(imgpath))
    for c in range(0,img.size[0],width):
        j=0
        for r in range(0,img.size[1],height):
            print([c,r])
            if c+width<img.size[0]:
                c_bound=c+width
            else:
                c_bound=img.size[0]
            if r+height<img.size[1]:
                r_bound=r+height
            else:
                r_bound=img.size[1]
            
            img_crop=img.crop((c,r,c_bound,r_bound))
            print(img_crop.size)
            img_crop.save(f"{croppath1}/{imgpath.stem}_c{i:03d}_r{j:03d}.jpg")
            print(f"{croppath1}/{imgpath.stem}_c{i:03d}_r{j:03d}.jpg")
            imsize.append(img_crop.size)
            j=j+1
        i=i+1
        

with open(str(path) + '/im_sizes.txt', 'w') as f:
    for item in imsize:
        f.write(f"{item[0]}\t{item[1]}\n")
    f.write(f"{i}\t{j}")
# %%
list(path.glob('**/*.png'))
#%%
list(path.glob('*.jpg'))
# %%
item[0]
# %%
croppath=imgpath.parents[1].joinpath('crop')
#%%
croppath.mkdir(parents=True, exist_ok=True)
croppath.joinpath(imgpath.parent.stem)