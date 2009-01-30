function result = isOdd(numbers);
% isOdd(number)
%	isOdd(numbers) returns 1 if number is odd 0 otherwise.  
%	numbers must be an integer.
%
% Dan S. Lee

result = 1 - (numbers == (floor(numbers/2) * 2));
