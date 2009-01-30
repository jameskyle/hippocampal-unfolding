function [outImage,cSize]= imCrop(inImage,cRect,imSize)
%
%AUTHOR:  Wandell
%PURPOSE:
%  Crop and return a rectangular portion of an image
%
%  Used in the format
%
%  [outImage outSize] = imCrop(inImage,cRect)
%
%	imCrop assumes that the image is a 2d matrix and returns
%	the relevant section.
%
%  In the format
%
%  [outImage outSize] = imCrop(inImage,cRect,imSize)
%	
%	imCrop assumes the image is a 1d vector with row and column
%	sizes in imSize.  It converts inImage a 2d matrix
%	extracts the relevant region, and returns the data
%	as a 1d vector rather, like the input.
%
%        inImage: is the image data
%        cRect:   coordinates of a rectangle in [X,Y] format.
%		imCrop uses min(X),min(Y) as the upper left
%		and max(X),max(Y) as the lower right of rect.
%
%	 imSize:  the row and column sizes of the inImage.
%		images are numbered from [1,1] in the
%		upper left hand corner and increasing to lower right.
%

cropmin = min(cRect);
cropmax = max(cRect);

if nargin == 3

 if min(size(inImage)) ~= 1
    disp('With these arguments, imCrop expects the input image')
    disp('to be one-dimensional.')
    return
 end

 inImage = reshape(inImage,imSize(1),imSize(2));
 outImage = inImage(cropmin(2):cropmax(2),cropmin(1):cropmax(1));
 cSize = size(outImage);

%Return the image as a vector

 outImage = reshape(outImage,1,prod(cSize)); 

elseif nargin == 2

 outImage = inImage(cropmin(2):cropmax(2),cropmin(1):cropmax(1));
 cSize = size(outImage);

else
  disp('Wrong number of arguments to imCrop');
end


return

