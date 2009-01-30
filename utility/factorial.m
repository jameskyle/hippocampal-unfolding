function y=factorial(x)
% FACTORIAL: y=factorial(x)

if x>0
	y=prod(1:x);
else
	y=0;
end
