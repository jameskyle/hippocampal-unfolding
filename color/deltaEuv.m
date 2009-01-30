function dEuv = deltaEuv(xyz1,xyz2,white)
% dEuv = deltaEuv(xyz1,xyz2,white): 
%   xyz1 and xyz2 are 3 x N matrices  with xyz in columns 
%   white is a 3 vector of the white point
%   dEuv is a vector of delta Euv values comparing the two data sets

m = size(xyz1);
u = size(xyz2);
if(m ~= u)
  disp('xyz1 and xyz2 must have the same dimensions')
  return
end
if(m(1) ~= 3)
  disp('xyz1 and xyz2 must have three rows or they ain"t XYZ')
end
a = xyz2luv(xyz1,white);
b = xyz2luv(xyz2,white);
d = a - b;

%  Compute the norm of the difference
nData = m(2);
dEuv = [1:nData];
for i=1:nData
  dEuv(i) = norm( d(:,i));   
end

