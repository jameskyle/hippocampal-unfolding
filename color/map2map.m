function outMap = map2map(inMap, gTable)
% outMap = map2map(inMap, gTable)
%
% AUTHOR: Wandell
% DATE:  06/29/94
% PURPOSE:
%
%	Convert a colormap to a new color map based on the
%	entries of a look-up table, gTable.
%	
%	inMap:  The input colormap  (range [0,1]).
%	outMap: The converted colormap (range [0,1]).
%	gTable: The lookup table used to convert the r,g, and b values
%		in inMap to outMap.
%
%       The routine map2map can be used to convert between framebuffer 
%	colormaps and colormaps that represent the data in terms of
%	linear intensity.
%
%	For example, to convert an index image known only in terms
%	of framebuffer entries of a monitor to an estimate of the 
%	linear intensities we determine the gamma correction table
%	for the monitor, gTable, and then we apply:
%	
%		outMap = map2map(inMap,gTable);
%	 	[r g b] = ind2rgb(indexes, outMap);
%
%	The resulting r,g,b images are in linear intensity units.
%	
%	To convert from linear intensity units back to framebuffer
%	values we perform the inverse operation:
%
%	First, make sure that the image is represented with respect
%	to a linear-intensity index color map.
%
%		[indexImage linMap]= rgb2ind(r,g,b);
%
%	Then, correct the map for the frame-buffer nonlinearity via
%
%		fbMap = map2map(linMap,gTableInv);
%		
%	where gTableInv is the inverse lookup table.
%

%
%	Scale the inMap values to fill up the range of the
%	gTable used to convert the map.
%
%
%	Debugging
% load hit489Gam
% gTable = hit489Gam;
% inMap = gray(256);
%
%
gPrecision = size(gTable,1);
tmp = round((gPrecision-1)*inMap + 1);

r = tmp(:,1);
g = tmp(:,2);
b = tmp(:,3);

%
%N.B.  size(outMap) = size(inMap), not size(gTable).
%
outMap(:,1) = gTable(r,1);
outMap(:,2) = gTable(g,2);
outMap(:,3) = gTable(b,3);

