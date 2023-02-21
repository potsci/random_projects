%% Calculate Euler number and get binary image
%clear
%%
[file,path] = uigetfile('*.png');
%%
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end
I = fullfile(path,file);
%imshow(I)


I = imread(I);
 rgbImage = I(:,:,1:1);
 rescaled=imresize(rgbImage,1);%,'bicubic');
%imshow(rgbImage);
%P = rgb2gray(I);
%imshow(P)
BW = imbinarize(rescaled(:,:));
%figure
%imshow(BW)
%BW = imbinarize(I);
%%
path
%%
figure
[label_matrix,n_labels] = bwlabel(BW,4);
%gedoens = ~bwareaopen(~gedoens2,0,4);
imshow(label_matrix)
% sengel = imcrop(gedoens);
% imshow(sengel);
%eul=bweuler(gedoens)
%%
%figure
%imshow(label_matrix)
%%
label_i=2 %%22 for relatively round problematic particle

prop=regionprops(~label_matrix,"FilledImage",'Circularity','Centroid','Perimeter','Area','Image','BoundingBox','ConvexHull','ConvexImage','BoundingBox');
%'Perimeter', 'Area', 'Centroid', 'Image'
%number_of_verts=FindNumberOfVertices(prop(6),prop(6).FilledImage)
threshold = 15;
figure
imshow(rescaled)
edges_all=[]
tic
padd=5
thresh=5
imisze=size(rescaled)
for i = 1:numel(prop)

    %edges = subpixelEdges(rescaled, threshold, 'SmoothingIter', 1); 
    %% show edges
    %visEdges(edges);
    %% https://de.mathworks.com/matlabcentral/fileexchange/48908-accurate-subpixel-edge-location
    y1=round(prop(i).BoundingBox(2));
    y2=round(prop(i).BoundingBox(2)+prop(i).BoundingBox(4));
    x1=round(prop(i).BoundingBox(1));
    x2=round(prop(i).BoundingBox(1)+prop(i).BoundingBox(3));
    if y2>imisze(1)
        y2=y2-1;
    end
    if x2>imisze(2)
        x2=x2-1;
    end
    if x1-padd<1
      x1=x1+padd;
    elseif y1-padd<1
        y1=y1+padd;
    elseif x2+padd>=imisze(2)
       x2=x2-padd;
    elseif y2+padd>=imisze(1)
       y2=y2-padd;
    end
    edges=subpixelEdges(rescaled(y1-padd:y2+padd,x1-padd:x2+padd),thresh);
    edges.x=edges.x+x1-padd-1;
    edges.y=edges.y+y1-padd-1;
    edges_all=[edges_all edges];
    %toc
    %%
%     figure
%     scatter(edges.x,edges.y,10,edges.curv)
%     colorbar
    %%
    %figure
    %imshow(rescaled(y1-5:y2+5,x1:x2+5))
    %imshow(rescaled)%(y1-5:y2+5,x1:x2+5))
    visEdges(edges);
end
toc

%%
figure
scatter(edges.x,edges.y,10,edges.curv,'filled')
visedges(edges)
colorbar


%%
%%
figure
imshow(rescaled)
visEdges(edges)
%%
prop(i).BoundingBox(2)+prop(i).BoundingBox(4)
%%
figure
imshow(rescaled(y1:y2-1,x1:x2))
figure
imshow(prop(i).FilledImage)
%%
% x1=round(prop(2).BoundingBox(1),TieBreaker="tozero")
% x2=round(prop(2).BoundingBox(1)+prop(2).BoundingBox(3),TieBreaker="tozero")
% y1=round(prop(2).BoundingBox(2),TieBreaker="tozero")
% y2=round(prop(2).BoundingBox(2)+prop(2).BoundingBox(4),TieBreaker="tozero")
%%
%resize(round(prop(1).BoundingBox(1))
figure
imshow(rescaled(y1:y2,x1:x2))

%%
figure
imshow(prop(i).FilledImage)
%%
figure
imshow(rescaled)
h=gca
h.Visible= 'On';


%%
figure
imshow(prop(label_i).FilledImage)
figure
imshow(prop(label_i).ConvexImage)
%%
%prop(i).Area
%%
if prop(label_i).Area>= 64
rescaled=prop(label_i).FilledImage;
disp('check')
%figure
%plot(R);
figure
imshow(padarray(rescaled,[1 1],0));
tmpimp=prop(label_i).FilledImage;
%e_det=edge(prop(2).Image);
padded=padarray(rescaled,[5 5]);
%padded=imresize(padded,1);
e_det=edge(padded);
figure
imshow(e_det);
[H,T,R] = hough(e_det,'RhoResolution',1,'Theta',-90:0.5:89);
end
%% rho=1 means equivalent to pixel size, this seems to be good. theta to small seems also bad


%%
max(H(:))
%%
nh_size=uint8(size(H)/50) %% the default of the matlab houghpeaks does find the peaks that are far to close
for i=1:size(nh_size)+1
    if mod(nh_size(i),2)==0
        nh_size(i)=nh_size(i)+1
        disp(":)")
    end
end
% temp=[33 19]
% %%
% T_max =T(P(:,2));
% R_max=R(P(:,1));
% figure
% plot(R_max,'color','red')
% hold on
% plot(T_max,'color','blue')
% %%
% figure
% plot(T_max,-R_max)
% %%
% for i =1:100
% disp(H(P(i)))
% end
% %%
% P
% %%
% %pek=findpeaks(H(:))
% [e,ind]=sortrows(T_max);
% f=R_max(index)
%%
%%
figure
%somehow we have to rule out, that we finde peaks that belong to spherical
%objects
P=houghpeaks(H,50,'Threshold',0.1*max(H(:)),'NHoodSize',double(nh_size)); %%make a thresholding for the peaks, that if there are multiple peaks within a too close vincinity, they will be regarded as one.
%imshow(imadjust(rescale(H)),[],'XData',T,'YData',R,'InitialMagnification','fit');
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

plot(T(P(:,2)),R(P(:,1)),'s','color','g'); 

%%
if size(P,1)>=10
    disp("round particle")
end
%%
lines=houghlines(e_det,T,R,P,'FillGap',5,'MinLength',7) %couple these params with image size
figure, imshow(e_det), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
%%

P
%%
figure
imshow(imadjust(rescale(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
%%
temp=int8(size(H)/10)
%%
for i=1:size(temp)+1
    if mod(temp(i),2)==0
        temp(i)=temp(i)+1
        disp(":)")
    end
end
mod(temp,2)
    %%
figure 
imshow(H,'XData',T,'Ydata',R)
%% Color only important

[B,L] = bwboundaries(gedoens,'noholes');
%imshow(I); 
hold on;
colors=['b' 'g' 'r' 'c' 'm' 'y'];
for k=1:length(B),
  boundary = B{k};
  cidx = mod(k,length(colors))+1;
  plot(boundary(:,2), boundary(:,1),...
       colors(cidx),'LineWidth',1.5);
end
%%


%%
figure
SE=strel('disk',10)

BW2 = imclose(e_det,SE);
imshow(BW2)
%%
[y,x]=find(e_det);
%%
figure
scatter(x,y)
%%
shp=alphaShape(x,y)
%%
figure
plot(shp)
%%
bon=boundary(x,y,1);
%%
figure
scatter(x(bon),y(bon))
%% https://web.archive.org/web/20161011113446/http://www.abecedarical.com/zenosamples/zs_circle3pts.html
i=2
x
a=[x(i-1)^2+y(i-1)^2 x(i-1) y(i-1); x(i)^2+y(i)^2 x(i) y(i); x(i-1)^2+y(i-1)^2 x(i-1) y(i-1)]
x1=x(bon(i-1)),y1=y(bon(i-1))
x2=x(bon(i)),y2=y(bon(i))
x3=x(bon(i+1)),y3=y(bon(i+1))
disp(['det' det(a)])
%%

%%
figure
plot(x(bon(1:10)),y(bon(1:10)))
%det(a)
%%
r_all=[]
tic
window=10; %full window is window*2+1
for i =1:numel(bon)
    
    if i<=window
       [~,~,r]=circlefit([x(bon(end-(window-i):end));x(bon(1:window+i))],[y(bon(end-(window-i):end));y(bon(1:(window+i)))]);
    elseif i>(numel(bon)-window)
         [~,~,r]=circlefit([x(bon(1:(i-numel(bon))+window));x(bon(i-window:end))],[y(bon(1:(i-numel(bon))+window));y(bon(i-window:end))]);
   else
        
         [~,~,r]=circlefit(x(bon(i-window:i+window)),y(bon(i-window:i+window)));
         
         if r>=max(size(e_det)) || isnan(r)
         r=0;100*max(size(e_det)); %plot(x(bon(i-window:i+window)),y(bon(i-window:i+window)));
           %hold on
         end
            
    end
    r_all=[r_all r];
    c_all=1./r_all;

    end
%end
toc
%%
%map=r_all
%colormap(r_all)
max(r_all)/1e20
%%
cm = colormap(parula(max(r_all)/1e20)); 
%%
figure
scatter(x,y)
%%
figure
scatter(x(bon),y(bon),10,r_all)
%plot(x(bon),y(bon),'Color',cm)
colorbar()
%%
figure 
scatter(linspace(1,numel(r_all),numel(r_all)),smooth(r_all))
%%
r=circlefit(x(bon(i-window:i+window)),y(bon(i-window:i+window)));
%%
i=652
window=3
disp([x(bon(i-window:end));x(bon(1:end-(i)))])
%%
x(bon(1:3))
x(bon(end-2:end))
%%
window=3
i=651
[x(bon(1:(i-numel(bon))+window));x(bon(i-window:end))]
%%
figure 
plot([x(bon(end-5:end));x(bon(1:5))],[y(bon(end-5:end));y(bon(1:5))])
%&toc
%%
numel(bon)
%%


% SUBPIXEL EDGES - EXAMPLE 1 -----------
% SUBPIXEL EDGE DETECTION IN A SYNTHETIC IMAGE
addpath(genpath('.'));
%% syntethic ring
imageSize = 35;
xCenter = imageSize/2;
yCenter = imageSize/2;
innerRadius = 8.0;
outerRadius = 10.0;
innerIntensity = 100;
outerIntensity = 200;
gridResolution = 100;
image = ring(imageSize, imageSize, xCenter, yCenter, ...
    innerRadius, outerRadius, innerIntensity, outerIntensity, ...
    gridResolution);
imshow(image/255,'InitialMagnification', 'fit');
%% subpixel detection
threshold = 15;
edges = subpixelEdges(rescaled, threshold, 'SmoothingIter', 1); 
%% show edges
visEdges(edges);
%% https://de.mathworks.com/matlabcentral/fileexchange/48908-accurate-subpixel-edge-location
tic
edges=subpixelEdges(rescaled(y1-5:y2+5,x1:x2+5),5)
toc
%%
figure
scatter(edges.x,edges.y,10,edges.curv)
colorbar
%%
figure
%imshow(rescaled(y1-5:y2+5,x1:x2+5))
imshow(rescaled)%(y1-5:y2+5,x1:x2+5))
visEdges(edges)


%%
x1=round(prop(2).BoundingBox(1))
x2=round(prop(2).BoundingBox(1)+prop(2).BoundingBox(3))
y1=round(prop(2).BoundingBox(2))
y2=round(prop(2).BoundingBox(2)+prop(2).BoundingBox(4))
%resize(round(prop(1).BoundingBox(1))
figure
imshow(rescaled(y1:y2,x1:x2))

%%
figure
imshow(prop(2).FilledImage)
%%
figure
imshow(rescaled)
h=gca
h.Visible= 'On';


%%
  Alignment(CS,'temp',instrument); %change this skript to make an if else to ask wheter ebsd is good or not
            load([localpath,'aligname'])
            disp([localpath,'aligname'])% the last saved path is saved to ebsdname.mat
            %disp(aligname)            
            [file_a,path_a] = uigetfile(aligname,'alignment file'); %different variable name, because they need to be different than in the .mat
            load([path_a '\' file_a]);
            
                if path_a~=0
                    aligname=[path_a,file_a]
                    save([localpath, 'aligname.mat'],"aligname");    
                    clear aligname;
                end














%%











figure
%Color everything
%[file,path] = uigetfile('*.tif');
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end
C = fullfile(path,file);
C = imread(C);
rgbImage2 = C(:,:,1:1);
BW2 = imbinarize(rgbImage2(:,:));
C = rand(320, 200) > 0.5;  % Binary test image
R   = 1;  % Value in range [0, 1]
G   = 1;
B   = 0;
RGB = cat(3, gedoens * R, gedoens * G, gedoens * B);
imshow(RGB)
%Overlay Pictures
F = imfuse(label2rgb(L, 'hsv', [0.5 0.5 0.5]),I);
imshow(F)
%%
figure 
imshow(label2rgb(L, 'hsv'))

function numVertices = FindNumberOfVertices(blobMeasurements, labeledImage) %%https://de.mathworks.com/matlabcentral/answers/1687304-find-figures-squares-rectangles-circles-with-matlab#answer_933499
try
	numVertices = 0; % Initialize.
	% Get the number of blobs in the image.
	numRegions = length(blobMeasurements);
	hFig = figure;
	promptUser = true; % Let user see the curves.
	
	% For each blob, get its boundaries and find the distance from the centroid to each boundary point.
	for k = 1 : numRegions
		% Extract just this blob alone.
		thisBlob = ismember(labeledImage, k) > 0;
		if promptUser % Let user see the image.
			cla;
			imshow(thisBlob);
		end
		% Find the boundaries
		thisBoundary = bwboundaries(thisBlob);
		thisBoundary = cell2mat(thisBoundary); % Convert from cell to double.
		% Get x and y
		x = thisBoundary(:, 2);
		y = thisBoundary(:, 1);
		% Get the centroid
		xCenter = blobMeasurements(k).Centroid(1);
		yCenter = blobMeasurements(k).Centroid(2);
		% Compute distances
		distances = sqrt((x - xCenter).^2 + (y - yCenter).^2);
		if promptUser % Let user see the curves.
			% Plot the distances.
			plot(distances, 'b-', 'LineWidth', 3);
			grid on;
			message = sprintf('Centroid to perimeter distances for shape #%d', k);
			title(message, 'FontSize', 15);
			% Scale y axis
			yl = ylim();
			ylim([0, yl(2)]); % Set lower limit to 0.
		end
		
		% Find the range of the peaks
		peakRange = max(distances) - min(distances);
		minPeakHeight = 0.5 * peakRange;
		% Find the peaks
		[peakValues, peakIndexes] = findpeaks(distances, 'MinPeakProminence', minPeakHeight);
		% Find the valueys.
		[valleyValues, valleyIndexes] = findpeaks(-distances, 'MinPeakProminence', minPeakHeight);
		numVertices(k) = max([length(peakValues), length(valleyValues)]);
		% Circles seem to have a ton of peaks due to the very small range and quanitization of the image.
		% If the number of peaks is more than 10, make it zero to indicate a circle.
		if numVertices(k) > 10
			numVertices(k) = 0;
		end
		
		if promptUser % Let user see the curves.
			% Plot the peaks.
			hold on;
			plot(peakIndexes, distances(peakIndexes), 'r^', 'MarkerSize', 10, 'LineWidth', 2);
			
			% Plot the valleys.
			hold on;
			plot(valleyIndexes, distances(valleyIndexes), 'rv', 'MarkerSize', 10, 'LineWidth', 2);
			
			message = sprintf('Centroid to perimeter distances for shape #%d.  Found %d peaks.', k, numVertices(k));
			title(message, 'FontSize', 20);
			
			% The figure un-maximizes each time when we call cla, so let's maximize it again.
			% Set up figure properties:
			% Enlarge figure to full screen.
			set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
			% Get rid of tool bar and pulldown menus that are along top of figure.
% 			set(gcf, 'Toolbar', 'none', 'Menu', 'none');
			% Give a name to the title bar.
			set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off')
			
			% Let user see this shape's distances plotted before continuing.
			promptMessage = sprintf('Do you want to Continue processing,\nor Cancel processing?');
			titleBarCaption = 'Continue?';
			button = questdlg(promptMessage, titleBarCaption, 'Continue', 'Cancel', 'Continue');
			if strcmpi(button, 'Cancel')
				promptUser = false;
			end
		end
	end
	close(hFig);
catch ME
	errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
		ME.stack(1).name, ME.stack(1).line, ME.message);
	fprintf(1, '%s\n', errorMessage);
	uiwait(warndlg(errorMessage));
end
end
%%
function [xCenter, yCenter, radius, a] = circlefit(x, y)
% circlefit(): Fits a circle through a set of points in the x - y plane.
% USAGE :
% [xCenter, yCenter, radius, a] = circlefit(X, Y)
% The output is the center point (xCenter, yCenter) and the radius of the fitted circle.
% "a" is an optional output vector describing the coefficients in the circle's equation:
%     x ^ 2 + y ^ 2 + a(1) * x + a(2) * y + a(3) = 0
% by Bucher Izhak 25 - Oct - 1991

numPoints = numel(x);
xx = x .* x;
yy = y .* y;
xy = x .* y;
A = [sum(x),  sum(y),  numPoints;
     sum(xy), sum(yy), sum(y);
     sum(xx), sum(xy), sum(x)];
B = [-sum(xx + yy) ;
     -sum(xx .* y + yy .* y);
     -sum(xx .* x + xy .* y)];
a = A \ B;
xCenter = -.5 * a(1);
yCenter = -.5 * a(2);
radius  =  sqrt((a(1) ^ 2 + a(2) ^ 2) / 4 - a(3));
end
