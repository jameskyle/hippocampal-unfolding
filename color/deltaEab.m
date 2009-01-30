function dEab = deltaEab(xyz1,xyz2,white)
% deltaEuv(xyz1,xyz2,white): returns array of delta E_uv, xyz in columns 
%   Compute the array of delta Euv values for two matrices of xyz input
%   and the whitepoint.

nData = size(xyz1,2);
if(nData ~= size(xyz2,2))
  error('xyz1 and xyz2 must have the same number of columns.')
elseif( size(xyz1,1) ~= 3 | size(xyz2,1) ~= 3)
  error('xyz1 and xyz2 must have the three rows.')
end

a = xyz2lab(xyz1,white);
b = xyz2lab(xyz2,white);
d = a - b;

%  Compute the norm of the difference
dEab = [1:nData];
for i=1:nData
  dEab(i) = norm( d(:,i));   
end


