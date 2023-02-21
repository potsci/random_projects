function [Jregistered,tform,scale]=pre_align(SubFolder,SEA,GB,n)
localpath = which("pre_align.m")
localpath = which("pre_align.m")
    localpath=erase(localpath,"pre_align.m")
    localpath=[localpath '..\pathfiles\']
    disp(localpath)
%     load([localpath,'ebsdname']) % the last saved path is saved to ebsdname.mat
%     [file,path] = uigetfile(ebsdname,'EBSD file'); 
%     if path~=0
%         ebsdname=[path,file]
%         save([localpath, 'ebsdname.mat'],"ebsdname");    
%         clear ebsdname;
%     end
    %[file,path] = uigetfile('.osc','EBSD File');
    %[ebsd,grainsI]=calEBSDor([path,file],cs,instrument); %calibration of the EBSD map (i.e. filtering and stuff)
    %ebsdI=
    %path=evalin('base','pwd')
    %ebsd=evalin('base','ebsd_plot')
    %grainsI=evalin('base','grains_plot')
    %an_substr="_temp"
    %% overlapping and alignment
    % ebsd data cropping
    
  %  [SubFolder,~,ebsdI]=EBSDcrop(path,ebsd,an_substr,grainsI);
    % load SE and grain boundary image
   
    %%
    
  %  qual=input('\nIs the quality of the EBSD map sufficient?: ','s'); %use "built-in" EDAX SE image for alignment if EBSD is bad
%    %         if strcmp(qual,'y')
%             load([localpath,'SEname']) % the last saved path is saved to ebsdname.mat
%             [file,path] = uigetfile(SEname,'Reference SE Image (.tif)'); 
%             if path~=0
%                 SEname=[path,file]
%                 save([localpath, 'SEname.mat'],"SEname");    
%                 clear SEname;
%             end
% 
%             SEA=imread([path,file]);
            %%
            s_sea=size(SEA);
            %%
%             GB=imread(SubFolder + "\GB.png");
            %s_GB=size(GB);
            %scale=s_GB(1)/s_sea(1);
            %SEA=imresize(SEA,scale);
            %%
            POINTS = readPoints(SEA,3);
            MPOINTS = readPoints(GB,3);
            % transformation
            tform = fitgeotrans(POINTS,MPOINTS,'similarity');
            Jregistered = imwarp(SEA,tform,'OutputView',imref2d(size(GB)));
         %%   % compare
 %           figure
%            imshowpair(GB,Jregistered, 'blend');
            %%
            %moving=im2gray(SEA);
            %fixed=im2gray(GB);
%            = im2gray(fixed);
%moving = im2gray(moving);
           % cpselect(SEA,GB)
            %%
            %%
            %figure
            %imshow(Jregistered)
            imwrite(Jregistered,[SubFolder, sprintf('\Jregistered_%i.tif',n)],'tif');
            % saveas(gcf,'I:\Fib\C2_zubair\HT_SE_image\Jregistered.png')
            %%
            %%
            
            close
            % save croping
          %   save(SubFolder+ '\alignment.mat','tform','Jregistered','POINTS','MPOINTS') ;
             %assignin('base','tform','Jregistered')
            %%
end  

        