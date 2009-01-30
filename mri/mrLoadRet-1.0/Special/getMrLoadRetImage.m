%  [im,mp] = getMrLoadRetImage(in,iSize,lo,hi)
%
%AUTHOR: BW & HB, 7/23/96
%DATE:
%PURPOSE:
% Return enough data about image currently displayed in
% mrLoadRet's window so that it can be saved as a tiff file using
% tiffwrite.  We have access to the raw image values (curImage),
% but we need to learn about the color map.
%
% This routine assumes that the mrLoadRet window is currently selected.
%
%ARGUMENTS:
%
% in =    raw values of the current image (curImage)
% iSize = current image size (curSize)
%
% Explain these better when you understand them.
% These arguments are optional.
%
% lo = the lowest value of the image, corresponding to the slider
% hi = the highest value in the image, corresponding to the slider
%
% CHANGES:
%   05.15.98
%   Changed the scaling in order to rid ourselves of the black dots.
%   Added the rounds to make sure the image values fall on ints.
%     We should probably get to uint8s in here some day.  -- BW, HAB
% 

function [out,mp] = getMrLoadRetImage(in, iSize, lo, hi) 

% mrLoadRet's color map uses the first 128 entries as gray
% scale and the upper entries to code color information
%
mp = colormap;

% You may have to read the slider values in mrLoadRet
% to scaling the image data nicely.  You can also set them by
% hand at input.
%

in = in(:);

% Adjust the ranges we display based on the slider values
% 
if (nargin < 4)
  global slimin slimax;
  if ~isempty(slimin)
    lo = max(in)*get(slimin,'value');
  else
    lo = min(in);
  end
  if ~isempty(slimax)
    hi = max(in)*get(slimax,'value');
  else
    hi = max(in);
  end
end

% Make sure the order of the slider values is OK!
%
if (lo >= hi)
  fprintf('getMrLoadRetImage:  Slider values are wrong.\n');
  hi = lo + .01;
end

% Find the positive values of the input image.  These
% are the anatomy portions of the image
%
anatomyImage = (in >= 0);

% Find the zero and negative values.  These code the overlay
% of the anatomy image
% 
low = ((in < lo) & anatomyImage);
in(low) = lo*ones(1,sum(low));
in(in>hi) = hi*ones(1,sum(in>hi));

% Scale the anatomical portions of the data to fill
% up the first 128 values of the color map, which 
% contain the gray-scale entries
%
in(anatomyImage) = round(scale(in(anatomyImage),1,128));

% Set the other parts of the image to the colored
% regions of the map, above 128.  The other parts run from -1 to
% -129. We want them to fall in the range 129,256.
% So, we flip the sign and then use scale.
% 
in(~anatomyImage) = round(scale(-in(~anatomyImage),129,256));

% Return a matrix of the proper size
%
out = reshape(in,iSize);



