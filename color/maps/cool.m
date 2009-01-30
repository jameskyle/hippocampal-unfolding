function c = cool(m)
%COOL	Shades of cyan and magenta color map.
%	COOL(M) returns an M-by-3 matrix containing a "cool" colormap.
%	COOL, by itself, is the same length as the current colormap.
%
%	For example, to reset the colormap of the current figure:
%
%	          colormap(cool)
%
%	See also HSV, GRAY, HOT, BONE, COPPER, PINK, FLAG, 
%	COLORMAP, RGBPLOT.

%	C. Moler, 8-19-92.
%	Copyright (c) 1984-93 by The MathWorks, Inc.

if nargin < 1, m = size(get(gcf,'colormap'),1); end
r = (0:m-1)'/max(m-1,1);
c = [r 1-r ones(m,1)]; 
