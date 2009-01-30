function spectrumMap = spectrumMap(mapLength)

%	
%   function spectrumMap = spectrumMap(mapLength)
%
% AUTHOR:
%    Wandell, July, 1994
%
% PURPOSE:
%   Create a colormap suitable for creating an image of the spectrum.
%   For example:
%
%		img = 1:64;
%		mp = spectrumMap(64);
%		image(img); colormap(mp);
%

if mapLength > 255
  error('mapLength is too large')
end

% Design a few key points and interpolate between
%
r = [.7 1 1 0 0 0 .9];
g = [0 0.2 1  1   .7 0 0.5];
b = [0 0 0 0 0.7 .8 1];
nSamples = length(r);

x = [1:(mapLength-1)/(length(r)-1):mapLength];
i = [1:mapLength];

rint = interp1(x,r,i);
gint = interp1(x,g,i);
bint = interp1(x,b,i);

spectrumMap = [rint,gint,bint];
