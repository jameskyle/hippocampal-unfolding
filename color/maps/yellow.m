function g = yellow(m)
%YELLOW	Linear yellow-scale color map.
%	YELLOW(M) returns an M-by-3 matrix containing a yellow-scale colormap.
%	YELLOW, by itself, is the same length as the current colormap.
%
%	For example, to reset the colormap of the current figure:
%
%	          colormap(yellow)
%
%	See also HSV, HOT, COOL, BONE, COPPER, PINK, FLAG, 
%	COLORMAP, RGBPLOT.

%	Copyright (c) 1984-92 by The MathWorks, Inc.

if nargin < 1, m = size(get(gcf,'colormap'),1); end
g = (0:m-1)'/max(m-1,1);
g = [g g zeros(size(g))];
