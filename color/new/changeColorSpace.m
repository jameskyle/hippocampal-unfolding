function outImage = changeColorSpace(inImage,colorMatrix)
%
% AUTHOR:  M. Zhang, B. Wandell
% DATE:    03.08.96
% PURPOSE:
%
%   outImage = changeColorSpace(inImage,colorMatrix)
%
%   The input image consists of a three input images, say R,G,B, joined as 
%
%		inImage = [ R G B];
%
% The output image has the same format
%
% The 3 x 3 color matrix converts column vectors in the input image
% representation into column vectors in the output representation.
%

%HISTORY:
%

[r c] = size(inImage);

% We put the pixels in the input image into the rows of a very
% large matrix
%
inImage = reshape(inImage, prod(size(inImage))/3,3);

% We post-multiply by colorMatrix' to convert the pixels to the output 
% color space
%
outImage = inImage*colorMatrix';

% Now we put the output image in the basic shape we use
%
outImage = reshape(outImage,r,c);

