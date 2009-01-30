function [res] = makeZonePlate(sz, ampl, ph)
% res = makeZonePlate([ydim xdim], ampl, phase)
%
% Make a "zone plate" image, centered at ([ydim xdim]+1)/2.
% ampl, default 1
% phase, default 0
%
% EPS, 6/96.

sz = sz(:);
if (size(sz,1) == 1)
  sz = [sz,sz];
end

mxsz = max(sz(1),sz(2));

if (exist('ampl') ~= 1)
  ampl = 1;
end

if (exist('ph') ~= 1)
  ph = 0;
end

if (exist('phase') ~= 1)
  phase = 0;
end

res = cos((pi/mxsz)*makeR(sz,2) + phase);

