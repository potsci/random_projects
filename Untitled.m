figure
imshow(zeros(250,250))
%%
h = drawellipse('Center',[125 125],'SemiAxes',[78 72], ...
    'RotationAngle',287,'StripeColor','m');
s= drawrectangle()
%%
mask=createMask(h);
%figure
imshow(mask)

%%
%circle(125,125,125,1)
figure
h=1
r=20
alpha=2*(acos(1-h/r))
P = plot_arc(alpha,-alpha,0,0,r);

%%
%%
% Create a logical image of a circle with specified
% diameter, center, and image size.
% First create the image.
H_all=[];
for s_img=51:50:302
    imageSizeX = s_img;
    imageSizeY = s_img;
    H_pixels=[];
    for height=0.01:0.02:0.5
    
        [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
        % Next create the circle in the image.
        
        centerY = round(imageSizeY/2);
        radius = round((imageSizeX)/2);
        h=round(height*radius);
        if h>0
            s=imageSizeY;
            radius=round((4*h^2+s^2)/(8*h));
            centerX =imageSizeX-radius+1;
            x_lim=imageSizeX/2 ;
            circlePixels=[];
            circlePixels = (rowsInImage - centerY).^2 ...
                + (columnsInImage - centerX).^2 < radius.^2;
            circlePixels(1:imageSizeY,1:centerX)=1;


            %figure
            %image(circlePixels) ;
            colormap([0 0 0; 1 1 1]);
            %title('Binary image of a circle');
            imwrite(circlePixels,[sprintf('E:/RWTH_Aachen/Promo/edge_dete/para_study/square_p_circle_seg_%ix%i_%i.png',imageSizeX,imageSizeY,height)]);
            I=circlePixels;
            prop=regionprops(I,"FilledImage",'Circularity','Centroid','Perimeter','Area','Image','BoundingBox','ConvexHull','ConvexImage');
            rescaled=prop(1).ConvexImage;
            %disp('check');
            %figure
            %plot(R);
            %figure
            %imshow(padarray(rescaled,[1 1],0));
            %tmpimp=prop(1).FilledImage;
            %e_det=edge(prop(2).Image);
            pad=5;
            padded=padarray(rescaled,[pad pad]);
            %padded=imresize(padded,1);
            e_det=edge(padded);
            %figure
            %imshow(e_det);
            [H,T,R] = hough(e_det,'RhoResolution',1,'Theta',-90:0.5:89);
            nh_size=uint8(size(H)/50); %% the default of the matlab houghpeaks does find the peaks that are far to close

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
            s_res=size(rescaled);
            max_x=round(size(H)/2);
            H(max_x(1)+s_res(1)+pad,max_x(2)+1);
            T();
            R(P(:,1));
            max_x=round(size(H)/2);
        
            
            
            
        
        end
        H_pixels=[H_pixels H(max_x(1)+s_res(1)+pad,max_x(2)+1)];
    end
    H_all=[H_all H_pixels];
end
%circlePixels(1:imageSizeY,1:x_lim)=0;
%%
figure
plot(H_all)
%%
plot(H_pixels)
