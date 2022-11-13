[file,path] = uigetfile('*.png');
%%
files=dir([path  '*.png'])
files().name
%%
i=120
I=imread([files(i).folder '\' files(i).name]);
%%
I=imread([files(i).folder '\' 'square_p_circle_seg_301x301_1.000000e-02.png']);%%
I=imread([files(i).folder '\' 'square_p_circle_seg_301x301_4.900000e-01.png']);
%%


prop=regionprops(I,"FilledImage",'Circularity','Centroid','Perimeter','Area','Image','BoundingBox','ConvexHull','ConvexImage');
rescaled=prop(1).ConvexImage;
disp('check')
%figure
%plot(R);
%figure
%imshow(padarray(rescaled,[1 1],0));
%tmpimp=prop(1).FilledImage;
%e_det=edge(prop(2).Image);
pad=5
padded=padarray(rescaled,[pad pad]);
%padded=imresize(padded,1);
e_det=edge(padded);
%figure
%imshow(e_det);
[H,T,R] = hough(e_det,'RhoResolution',1,'Theta',-90:0.5:89);
nh_size=uint8(size(H)/50) %% the default of the matlab houghpeaks does find the peaks that are far to close

%%
for i=1:size(nh_size)+1
    if mod(nh_size(i),2)==0
        nh_size(i)=nh_size(i)+1
        disp(":)")
    end
end

% figure

%somehow we have to rule out, that we finde peaks that belong to spherical
%objects
P=houghpeaks(H,4,'Threshold',0.1*max(H(:)),'NHoodSize',double(nh_size)); %%make a thresholding for the peaks, that if there are multiple peaks within a too close vincinity, they will be regarded as one.
%imshow(imadjust(rescale(H)),[],'XData',T,'YData',R,'InitialMagnification','fit');
% imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
% 
% plot(T(P(:,2)),R(P(:,1)),'s','color','g'); 
% %%
% figure
% imshow(rescale(H),'XData',T,'YData',R,...
%       'InitialMagnification','fit');
% axis on
% axis normal
%   hold on
%plot(X(index(pos),1),X(index(pos),2),'ro')
%%
s_res=size(rescaled)
max_x=round(size(H)/2)
H(max_x(1)+s_res(1)+pad,max_x(2)+1)
T()
R(P(:,1))
max_x=round(size(H)/2)