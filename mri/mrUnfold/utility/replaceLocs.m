function A = replaceLocs(A,rows,cols,value);
%
% A = replaceLocs(A,rows,cols,value)
%
% AUTHOR: Chial
% DATE : 02.03.98
% PURPOSE: Replace the values at the given row and column locations in
%          the matrix A with the given value.  If value is empty, the
%	   matrix A remains unchanged.
%

if ~isempty(value)
  selected = (cols - 1) * size(A,1) + rows;
  A(selected) = value;
end

return