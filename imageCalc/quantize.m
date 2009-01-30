function result = quantize(img, values)
% quantize(img, values)
%	Returns a matrix whose values have been quantized to the closest
%	value specified.  Quantization values may be any form, row vector,
%	column vector, or matrice.
%
% Functions called
%	closestTuple()
%
% Rick Anthony
% 11/18/93

if(nargin < 2)
    error('Two input arguments required');;
end


[rows cols] = size(img);

result = reshape(closestTuple(img(:)', values(:)'), rows, cols);


