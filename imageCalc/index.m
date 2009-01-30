function result = index(mat, y, x)
% index(y,x)
%	Returns the values of the matrix at the given indexes.  
%
% Rick Anthony
% 11/22/93

[rows cols] = size(mat);

result = mat(round(y(((y>=1) & (y<=rows)))), round(x(((x>=1) & (x<=cols)))));
