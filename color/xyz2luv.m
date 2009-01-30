function luv = xyz2luv(xyz,white)
%   luv = xyz2luv(xyz,white): 
%    xyz is a 3 x N matrix with xyz in columns
%    white is a 3 vector of the white point
%    luv is a 3 x N matrix with L*u*v* in the columns
%

if ( size(xyz,1) ~= 3 )
  error('Array xyz must have three rows')
end

m = size(white);
if ( max(m) ~= 3 | min(m) ~= 1) 
  error('Array white is not a three vector')
end

X = xyz(1,:); Y = xyz(2,:); Z = xyz(3,:);
Xn = white(1); Yn = white(2); Zn = white(3);

uw = (4.0 * Xn) / (Xn + 15.0*Yn + 3.0*Zn);
vw = (9.0 * Yn) / (Xn + 15.0*Yn + 3.0*Zn);

luv = zeros(3,size(xyz,2));

lY = (Y/Yn) < 0.008856;
if max(lY) == 0
 luv(1,:) = 116*(Y/Yn).^(1/3) - 16;
else
 disp('Small Y values')
 luv(1,lY) = 903.3 * (Y(lY)/Yn);
 luv(1,1 - lY) = 116*(Y(1-lY)/Yn).^(1/3) - 16;
end

denom = [1.0,15.0,3.0]*xyz;
u     = (4*X) ./ denom;
v     = (9*Y) ./ denom;
luv(2,:) = 13 * luv(1,:) .* (u - uw);
luv(3,:) = 13 * luv(1,:) .* (v - vw);
