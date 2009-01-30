function [res] = makeTheta(sz, origin)
% res = makeTheta([ydim xdim], phase, origin)
%
% Compute a matrix containing samples of an angle function (from -pi to pi),
% relative to angle PHASE, about given ORIGIN, default ([ydim xdim]+1)/2.
%
% EPS, 6/96.

sz = sz(:);
if (size(sz,1) == 1)
  sz = [sz,sz];
end

if (exist('phase') ~= 1)
  phase = 0;
end

if (exist('origin') ~= 1)
  origin = (sz + 1)/2;
end

%% FIX to add phase:
[xramp,yramp] = meshgrid([1:sz(1)]-origin(1),[1:sz(2)]-origin(2));

res = atan2(yramp,xramp);
