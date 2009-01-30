function y = revolve(func,method)
% revolve(func, method)
%	Generates a 2d function by revolving func about its first position.
%	Intermediate points are calculated using an interpolation scheme
%	described by method.  If a method is not specified the procedure
%	defaults to linear.
%
%	Valid methods:
%		'linear' - linear interpolation
%		'spline' - cubic spline interpolation
%		'cubic' - cubic interpolation
%
% Note: a 2n x 2n matrix results, where n is the length of func.
%
% Rick Anthony
% 6/28/93

% default to linear if a method isn't specified.
if nargin ~= 2,
    method = 'linear';
end

n = length(func);

% generate matrix of indices into func for one quadrant.
x = meshdom([0 1:n-1], 1:n);
y = x';
r = sqrt(x.*x + y.*y);

% mask off radii that are too big.
m = (r <= n-1);
r = r .* m;

y = zeros(size(r));

% Interpolate each column of indices.  There should be a method to
% do this as a matrix.
for i = 1:n,
    y(:,i) = interp1(0:n-1, func, r(i,:), method);
end

% mask off interpolated values that are out of the domain of func.
% this ensures radial symmetry.
y = y .* m;

% generate quadrants to concat.
q4 = y;
q3 = fliplr(q4);
q2 = flipud(q3);
q1 = fliplr(q2);

y = [q2 q1; q3 q4];


    

