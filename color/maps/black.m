function w = black(m);
%BLACK	All black monochrome color map.
%	BLACK(M) returns an M-by-3 matrix containing a black colormap.
%	BLACK, by itself, is the same length as the current colormap.
%
%	For example, to reset the colormap of the current figure:
%
%	          colormap(black)
%
%	See also HSV, GRAY, HOT, COOL, COPPER, PINK, FLAG, 
%	COLORMAP, RGBPLOT.

%	Copyright (c) 1984-93 by The MathWorks, Inc.

if nargin < 1, m = size(get(gcf,'colormap'),1); end
w = zeros(m,3);
