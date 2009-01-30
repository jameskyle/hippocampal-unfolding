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

function [out,mp] = getMrLoadRetImage(in, iSize, lo, hi) 

% mrLoadRet's color map uses the first 128 entries as gray
% scale and the upper entries to code color information
%
mp = colormap;

iSize
size(in)

% You may have to read the slider values in mrLoadRet
% to scaling the image data nicely.  You can also set them by
% hand at input.
%

% 7/07/97 Lea updated to 5.0
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

% Make sure the order is OK!
%
if (lo >= hi)
  hi = lo + .01;
end

% Find the positive values of the input image.  These
% are the anatomy portions of the iamge
%
regimage = (in >= 0);

% Find the negative values.  These code the overlay
%
low = ((in < lo) & regimage);
in(low) = lo*ones(1,sum(low));
in(in>hi) = hi*ones(1,sum(in>hi));

% Scale the anatomical portions of the data to fill
% up the first 128 values of the color map, which 
% contain the gray-scale entries
%
in(regimage) = scale(in(regimage),1,128);

% Set the other parts of the image to the colored
% regions of the map, above 128.
in(~regimage) = -in(~regimage)+128;

% Return a matrix of the proper size
%
out = reshape(in,iSize);



