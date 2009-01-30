%
%	Image Calculation and Display Routines
%
%  dataSize = xgobi(data1,data2,data3,data4,data5)
%   	-- Use xgobi to plot the data in the matrices
%  [croppedImage,cSize]= cropImage(inImage,imageSize,crop)
%	-- inImage is a 2d image
%	   imageSize is the image size
%          crop is a rect defining the upper and lower limits
%
%  [upIm, upSize] = upSample(im,imSize)
%	-- Upsample the im vector with shape imSize
%	The data are upsampled by pixel replication using
%       the Kronecker delta method.  Probably there is
%  	some subscripting method that would make it faster and
%	there should probably be a filter/interp method.
%
% [imDown,imDownSize] = downSample(im, imSize)
%  	-- Return a matrix containing every other entry of 
%	the input image vector.

