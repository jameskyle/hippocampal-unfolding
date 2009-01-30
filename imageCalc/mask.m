function result = mask(mat, masky, maskx)
% mask(mat, masky, maskx)
%	Returns a matrix where a periodic sequence of values in the 
%	x,y direction remains and all other values have been masked off.
%
%	Maskx defauls to the value of masky if unspecified.
%
%	ex. 
%		mask([1 2 3 4; 5 6 7 8; 9 0 1 2], 2, 3)
%
%	produces
%		[ 1 0 0 4; 
%		  0 0 0 0;
% 	  	  9 0 0 2 ]
%
% Rick Anthony
% 5/24/94
	

if(nargin < 3) maskx = masky; end

[rows, cols] = size(mat);

mask = (~rem(0:rows-1,masky)') * (~rem(0:cols-1,maskx));
result = mask .* mat;

