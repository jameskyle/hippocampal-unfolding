function result = LevelMake(n)
% LevelMake(n)
%	LevelMake(n) returns an multi level matrix expected by
%	ErrorD*Multi by evenly spacing the values from 0 to 1 and
% 	givin equal ranges to all values except the first and last
%	values which are given ranges half that of the others.
%	LevelMake(2) returns a matrix used of bi-level error diffusion.

if n < 2, error('sorry I need at least 2 levels'); end

range = ones(n,1) / (n-1);
range(1) = range(1)/2;
range(n) = range(n)/2;
range;

result = [(0:(n-1))'/(n-1) range];
