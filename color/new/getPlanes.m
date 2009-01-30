function [p1, p2, p3] = getPlanes(allplanes, whichplane)
% [p1, p2, p3] = getPlanes(allplanes, whichplane)
%
% Separate an image matrix which has 3 planes in to 3 individual matrices.
% allplanes -- concatenated image planes, in the form [plane1 plane2 plane3].
% whichplane -- specifies which planes to return. Defaults to [1 2 3]
% (get all 3 planes, and return in p1, p2, p3).
%
% The separated image planes are returned in the order given by whichplane.
%
% Xuemei Zhang
% Last Modified 1/28/96

if (nargin==1)
  whichplane = [1 2 3];
end  

[m,n] = size(allplanes);
n = round(n/3);

if (n*3 ~= size(allplanes,2))
  error('Input image allplanes is not the correct size.');
end

a = (whichplane-1) * n + 1;   % start indices
z = whichplane * n;           % end indices

p1 = allplanes(:, a(1):z(1));
if (nargout>1)
  p2 = allplanes(:, a(2):z(2));
end
if (nargout>2)
  p3 = allplanes(:, a(3):z(3));
end
