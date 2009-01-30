function [croppedImage,cSize]= cropImage(inImage,imageSize,crop)
%
%AUTHOR:  Wandell
%DATE:    Old....see below
%
%  [croppedImage,cSize]= cropImage(inImage,imageSize,crop)
%        inImage: a 2d image in 1d vector format
%	 inSize:  the row and col sizes of the image
%        crop:    a set of rectangular coordinates
%
% BUGS:
%	This routine has been superceded by imCrop.
%
if min(size(inImage)) ~= 1
  disp('cropImage requires a 1d format for the input image')
  return
end

cropmin = min(crop);
cropmax = max(crop);
inImage = reshape(inImage,imageSize(1),imageSize(2));
croppedImage = inImage(cropmin(2):cropmax(2),cropmin(1):cropmax(1));
cSize = size(croppedImage);

%
%  Return the image as a vector
%
croppedImage = reshape(croppedImage,1,prod(cSize));

