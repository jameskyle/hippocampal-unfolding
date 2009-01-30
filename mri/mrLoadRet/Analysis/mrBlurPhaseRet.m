function [sPh , kern ] = blurPhase(phImage,kSize,kSD,curSize)
%
% [sPh kern] = blurPhase(phImage,kSize,kSD,curSize)
%
%PURPOSE:
%	Smooth the phase image, averaging in the proper space to
%	avoid problems with wrapping the phase.
%
%
%AUTHOR:  Engel
%DATE:    Aug. 1, 1994
%
%kSize = [8 8]
%kSD = [3 3]
%phImage = ph(4,:);

if nargin ~= 4
  error('Wrong number of arguments')
  return
end

xph = cos(phImage);
yph = sin(phImage);

% Create the smoothing kernel
kern = mkGaussKernel(kSize,kSD);

xph = reshape(xph,curSize(1),curSize(2));
yph = reshape(yph,curSize(1),curSize(2));

xph = cirConv2(xph,kern);
yph = cirConv2(yph,kern);
%xph = convolvecirc(xph,kern);
%yph = convolvecirc(yph,kern);

xph = reshape(xph,1,prod(curSize));
yph = reshape(yph,1,prod(curSize));

sPh = atan2(yph,xph);


