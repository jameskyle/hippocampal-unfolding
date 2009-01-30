function result = random(n)
% random(n)
%	Return a random integer from 1 to n.
%
% Rick Anthony
% 11/18/93

result = ceil(n.*rand(size(n)));
