function [img,mask]=getImgPloy(m,n,x,y,rgb)
% Draw a image with size of m*n and there is a ploygon with color of rgb in
% it. The polygon is set by several points defined by x and y.
% Sample: [img,mask]=getImgPloy(50,100, [20,60,60],[20,20,40], [1,0,0]);
% In this sample, we draw a red triangle in the image with size of 100x100
% You can show the image by imshow(img);
mask=poly2mask(x,y,m,n);
r=rgb(1);g=rgb(2);b=rgb(3);
img=zeros(m,n,3);
img(:,:,1)=r*mask;img(:,:,2)=g*mask;img(:,:,3)=b*mask;