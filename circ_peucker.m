corners_max_specified=corner(rescaled,10,'QualityLevel',.5)

%%
figure
imshow(rescaled)
hold on
plot(corners_max_specified(:,1), corners_max_specified(:,2), ...
   '*', 'Color', 'm')
%%
%Open your image
%I = imread('square.png');
%I = im2bw(rescaled));
I=e_det;
%Compute the centroid
centroid = round(size(I)/2)
%centroid=prop(label_i).Centroid
%%
%Find the pixels that create the square
[x,y] = find(I);

%Change the origin
X = [y,x]-centroid;

%Sort the data
X = sortrows(X,[1 2]);

%Cartesian to polar coordinates
[theta,rho] = cart2pol(X(:,1),X(:,2));

%sort the polar coordinate according to the angle.
[POL,index] = sortrows([theta,rho],1);

%Smoothing, using a convolution
len = 15 %the smoothing factor
POL(:,2) = conv(POL(:,2),ones(len ,1),'same')./conv(ones(length(POL(:,2)),1),ones(len ,1),'same');
%%
figure
POL(:,2)=smooth(POL(:,2),50)
POL(:,2)=smooth(POL(:,2),50)
%Find the peaks
pfind = POL(:,2);
pfind(pfind<mean(pfind)) = 0;
[~,pos] = findpeaks(pfind);

%Change (again) the origin
X = X+centroid;


%Plot the result
plot(POL(:,1),POL(:,2))
hold on
plot(POL(pos,1),POL(pos,2),'ro')
figure
imshow(I)
hold on
plot(X(index(pos),1),X(index(pos),2),'ro')

%%
figure
imshow(imadjust(rescale(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
  hold on
plot(X(index(pos),1),X(index(pos),2),'ro')