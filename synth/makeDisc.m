function [res] = makeDisc(sz, rad, vals, origin)
% MAKEDISC: Make a "disk" image.  
%
% res = makeDisc([ydim xdim], radius, values, origin)
%
% RADIUS (default = min(size)/4) specifies the radius of the disk.  VALUES
% (default = [1,0]) should be a 2-vector containing the intensity value
% inside and outside the disk.  ORIGIN specifies the location of the center.
%
% EPS, 6/96.

sz = sz(:);
if (size(sz,1) == 1)
  sz = [sz,sz];
end
 
if (exist('rad') ~= 1)
  rad = min(sz(1),sz(2))/4;
end

if (exist('vals') ~= 1)
  vals = [1,0];
end

if (exist('origin') ~= 1)
  res = makeR(sz);
else
  res = makeR(sz,1,origin);
end

res = (vals(1) - vals(2)) * (res <= rad) + vals(2);
