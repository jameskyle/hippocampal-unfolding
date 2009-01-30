function M = setMatrixEntries(colV,rowV,M,v)
%
%   		 newMatrix = setMatrixEntries(colV,rowV,M,v)
%
%AUTHOR:  Boynton, Wandell
%DATE:    May 1, 1995
%PURPOSE:
%
%  Set the entries in a matrix when you have a list of row and column
%  values.
%
%	rowV:  Row values
%	colV:  Column values
%	v:     A vector of values (length(v) = length(rowV) = length(colV)
%
%	M:     The matrix to be set
%

% M = zeros(3,5);
% v = [-1 -4];
% rowV = [1 3]
% colV = [2 3]

[nRows nCols] = size(M);
M = M(:);
positions = ( round(colV) -1 ) *nRows + round(rowV);
M( positions ) = v;
M = reshape(M,nRows,nCols);
