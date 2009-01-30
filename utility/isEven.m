function result = isEven(numbers);
% isEven(number)
%	isEven(numbers) returns 1 if number is even 0 otherwise.  Returns
%	0 if number is not an integer and applies algorithm to all
%	members if numbers is a vector or matrix.
%
% Dan S. Lee

result = (numbers == (floor(numbers/2) * 2));
