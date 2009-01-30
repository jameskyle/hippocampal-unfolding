function [cSeries,cSize]= cropSeries(imSeries,imSize,imCrop)
%
%  CROPSERIES:    [cSeries, cSize] = cropSeries(imSeries,imSize,imCrop)
%        imSeries a matrix of 2d images
%	 imSize:  a 2 vector of image row x col
%        imCrop:  a rectidentifying the area to crop
%
%	cSeries:  cropped series of images
%	cSize:    size of the cropped images

cmin = min(imCrop);
cmax = max(imCrop);
cSize = fliplr(imCrop(2,:) - imCrop(1,:) + 1);
%
%	Build a set of locations to select out of the image
%
locs = zeros(imSize);
locs(cmin(2):cmax(2),cmin(1):cmax(1)) = ones(cSize);
locs = reshape(locs,1,prod(imSize));
locs = find(locs ~= 0);
%
%	Select out the locations
%
cSeries = imSeries(:,locs);


