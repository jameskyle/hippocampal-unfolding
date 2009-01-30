function [res] = makeImpulse(sz, origin, amplitude)
% res = makeImpulse([ydim xdim], origin, amplitude)
%
% Compute a matrix containing a single non-zero entry,
% at position ORIGIN (defaults to center), of value AMPLITUDE
% (defaults to 1).
%
% EPS, 6/96.

sz = sz(:);
if (size(sz,1) == 1)
  sz = [sz,sz];
end
 
if (exist('origin') ~= 1)
  origin = ceil((sz+1)/2);
end

if (exist('amplitude') ~= 1)
  amplitude = 1;
end

res = zeros(sz);
res(origin(1),origin(2)) = amplitude;
