function result = mkInvTable(table,numEntries)
%
%AUTHOR: Engel, Wandell
%DATE:   02.20.95
%
%PURPOSE:
%  Find the inverse of a gamma table that maps the frame-buffer entries used to
%  control a monitor into linear intensity.
%
%	table:  Gamma table from frame-buffer to linear intensity
%       numEntries:  Number of sample values in the inverse table
%	result: Inverse gamma table that maps from linear intensity to
%		frame-buffer value.

results = interp1(table,0:(length(table)-1),[0:(numEntries-1)]/numEntries);

