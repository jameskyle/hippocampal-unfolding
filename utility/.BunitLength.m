function  [normalized_matrix] = unit_length(matrix,dim)
% function [normalized_matrix] = unit_length(matrix,dim)
% USAGE: 	dim = 'r' for rows, 'c' for cols
% SYNOPSIS: 
% AUTHOR:   Poirson
% DATE:	    01.28.96
% HISTORY:
% NOTES:    

if nargin < 2 
	disp('ERROR unit_length(): Not enough input passed');
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
	disp('ERROR unit_length(): normalize rows or cols?');
	return;
end