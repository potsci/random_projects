#%%
from PIL import Image 
Image.MAX_IMAGE_PIXELS = None
from pathlib import *
#%%
path=Path('I:\Fib\\quasi-in-situ\\3mm_yolo\\eps5_5kv_noabc\\pano_stitch')

print(list(path.glob('*.jpg')))
#%%
height=5000
width=5000     
i=0
j=0
imsize=[]
croppath=path.joinpath('crop')
croppath.mkdir(parents=True, exist_ok=True)
for imgpath in list(path.glob('*.jpg')):
    img = Image.open(str(imgpath))
    for c in range(0,img.size[0],width):
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
            img_crop.save(f"{croppath}/{imgpath.stem}_r{j:03d}_c{i:03d}.jpg")
            imsize.append(img_crop.size)
            j=j+1
        i=i+1
        j=0

with open(str(path) + '/im_sizes.txt', 'w') as f:
    for item in imsize:
        f.write(f"{item[0]}\t{item[1]}\n")
# %%
list(path.glob('*.jpg'))
# %%
item[0]
# %%
