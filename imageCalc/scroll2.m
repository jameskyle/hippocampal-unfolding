function result = scroll2(img, y, x)
% scroll2(mat, y, x)
% 	Returns the matrix scrolled in the x and y directions by the amount
%	specified.
%
% Functions called
%	mod()
% 
% Rick Anthony
% 11/18/93

[m n] = size(img);

x = mod(x,n);
y = mod(y,m);

result = [img(m-y+1:m,n-x+1:n) img(m-y+1:m,1:n-x); 
          img(1:m-y,n-x+1:n) img(1:m-y,1:n-x)];

