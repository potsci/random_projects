%% 
localpath = which("select_files.m")
    localpath=erase(localpath,"select_files.m")
    localpath=[localpath 'pathfiles\']
    disp(localpath)

%% Load registration images
another='y'

load([localpath,'SEname']) % the last saved path is saved to ebsdname.mat
[file,path] = uigetfile(SEname,'load eps0'); 
if path~=0
    SEname=[path,file]
    save(strcat(localpath, 'SEname.mat'),'SEname');    
    clear SEname;
end
%%
eps0=imread([path,file]);

i=1
%%
while strcmp(another,'y')
load([localpath,'SEname']) % the last saved path is saved to ebsdname.mat
[file,path] = uigetfile(SEname,'load next deformation step'); 
if path~=0
    SEname=[path,file]
    save([localpath, 'SEname.mat'],"SEname");    
    clear SEname;
end
%%
eps_n=imread([path,file]);


%% Registration 
folder=path
disp('starting')
%[Jregistered,tform_glob,scale]= pre_align(folder,eps_n,eps0,i); %(CS,'temp',instrument); %Alignment skript from Pei, Gibson 2021, modified
%%
            MPOINTS = readPoints(eps_n,3);
            POINTS = readPoints(eps0,3);
            tform = fitgeotrans(MPOINTS,POINTS,'similarity');
           %%
            Jregistered = imwarp(eps_n,tform,'OutputView',imref2d(size(eps0)));
            save_path=[path, sprintf('\\Jregistered_%i.tif',i)]
            imwrite(Jregistered,save_path);         
            close
            % save


%%



another=input('use another panorama? : \n')
i=i+1
end
