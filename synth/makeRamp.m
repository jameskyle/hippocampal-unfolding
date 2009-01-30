function [res] = makeRamp(sz, dir, slope, intercept, origin)
% res = makeRamp([ydim xdim], direction, slope, intercept, origin)
%
% Compute a matrix containing samples of a ramp function, with given
% gradiant DIRECTION (radians, default 0), SLOPE (per pixel, default 1), and
% a value of INTERCEPT (default 0) at the ORIGIN (default [1 1]).
%
% EPS, 6/96.

if (exist('dir') ~= 1)
  dir = 0;
end
 
if (exist('slope') ~= 1)
  slope = 1;
end
 
if (exist('intercept') ~= 1)
  intercept = 0;
end
 
if (exist('origin') ~= 1)
  origin = [1 1];
end

sz = sz(:);
if (size(sz,1) == 1)
  sz = [sz,sz];
end

[xramp,yramp] = meshgrid(slope*cos(dir)*([1:sz(2)]-origin(2)), ...
    slope*sin(dir)*([sz(1):-1:1]+(origin(1)-sz(1)-1)));

res = xramp + yramp;
