function newImage=linearWarpImage(im,M,NA)
%    newImage=linearWarpImage(im,M,NA)
% This function simply applies a linear warp to an image.
% The linear warp is given by the matrix M.
% The value of NA is used to replace any NaNs in the result
% so it can be displayed.
% DJF '97

if ~exist('NA')
  NA =255;
end

xdim=size(im,2);
ydim=size(im,1);

[x,y]=meshgrid(1:size(im,2),1:size(im,1));
xcenter=xdim/2;
ycenter=ydim/2;
newCoords = M * [x(:)'-xcenter; y(:)'-ycenter];
xPrime=reshape(newCoords(1,:),ydim,xdim) + xcenter;
yPrime=reshape(newCoords(2,:),ydim,xdim) + ycenter;

newImage=interp2(x,y,im,xPrime,yPrime);

newImage = reshape(newImage, 1, ydim*xdim);
nan_i = find(isnan(newImage));
newImage(nan_i)= NA * ones(1,size(nan_i,2));
newImage = reshape(newImage, ydim, xdim);



