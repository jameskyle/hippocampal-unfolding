function  [normalized_matrix] = unitLength(matrix,dim)
% 
% normalized_matrix = unitLength(matrix,dim)
% 
% AUTHOR:   Poirson
% DATE:	    01.28.96
% PURPOSE:
%   Convert the rows (or columns) of a matrix to have unit
% length. 
% ARGUMENTS:
%     matrix: input matrix
%     dim: 'r' or 'c' to normalize rows or columns, respectively.
%     
% HISTORY:
% NOTES:    
% 

if nargin < 2 
  disp('ERROR unitLength(): Not enough input passed');
  return;
end

a = matrix.^2;

if strcmp(dim,'r') == 1
	b = sum(a');
	l = inv(diag(b.^0.5));
	normalized_matrix = l*matrix;
elseif strcmp(dim,'c') == 1
	b = sum(a);
	l = inv(diag(b.^0.5));
	normalized_matrix = matrix*l;
else
	disp('ERROR unitLength(): normalize rows or cols?');
	return;
end
