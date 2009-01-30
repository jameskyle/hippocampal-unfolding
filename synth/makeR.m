function [res] = makeR(sz, expt, origin)
% res = makeR([ydim xdim], expt, origin)
%
% Compute a matrix containing samples of a radial ramp function.
% EXPT specifies exponent r^expt, default 1.
% ORIGIN specifies center point, default ([ydim xdim])+1/2.
%
% EPS, 6/96.

sz = sz(:);
if (size(sz,1) == 1)
  sz = [sz,sz];
end
 
if (exist('expt') ~= 1)
  expt = 1;
end

if (exist('origin') ~= 1)
  origin = (sz + 1)/2;
end

[xramp,yramp] = meshgrid([1:sz(2)]-origin(2),[1:sz(1)]-origin(1));

res = (xramp.^2 + yramp.^2).^(expt/2);
