function lab = xyz2lab(xyz,white)
%   xyz2lab(xyz,white)
%     xyz is a 3 x N matrix with xyz in columns
%     white is a length 3 vector with the white point.
%
%	lab is a 3 x N matrix of [Lstar;astar;bstar]
%
%   Formulae are taken from Wyszecki and Stiles, page 167.
%

if ( size(xyz,1) ~= 3 )
  error('Array xyz must have three rows')
end

[m,n] = size(white);
if ( (max(m,n) ~= 3) | (min(m,n) ~= 1) )
  error('white must be a three vector')
end

X = xyz(1,:); 
Y = xyz(2,:); 
Z = xyz(3,:);

Xn = white(1); 
Yn = white(2); 
Zn = white(3);

%
%	Allocate space
%
lab = zeros(3,size(xyz,2));
fX = zeros(1,size(xyz,2));
fY = zeros(1,size(xyz,2));
fZ = zeros(1,size(xyz,2));

%
%	Find the indices below the limits of the formula
%
lX = (X/Xn) < 0.008856;
lY = (Y/Yn) < 0.008856;
lZ = (Z/Zn) < 0.008856;

if max(lY) == 0
 lab(1,:) = 116*(Y/Yn).^(1/3) - 16.0;
 fY = (Y/Yn) .^(1/3);
else
 disp('Small Y values'); 
 lab(1,(1-lY)) = 116*(Y(1-lY)/Yn).^(1/3) - 16.0;
 lab(1,lY) = 903.3*(Y(lY)/Yn);

 fY(1-lY) = (Y(1-lY)/Yn) .^(1/3);
 fY(lY) = 7.787*(Y(lY)/Yn) + 16/116;
end

if max(lX) == 0
 fX = (X/Xn) .^(1/3);
else
 disp('Small X values'); 
 fX(1-lX) = (X(1-lX)/Xn) .^(1/3);
 fX(lX) = 7.787*(X(lX)/Xn) + 16/116;
end

if max(lZ) == 0
 fZ = (Z/Zn) .^(1/3);
else
 disp('Small Z values'); 
 fZ(1-lZ) = (Z(1-lZ)/Zn) .^(1/3);
 fZ(lZ) = 7.787*(Z(lZ)/Zn) + 16/116;
end

lab(2,:) = 500.0*(fX - fY);
lab(3,:) = 200.0*(fY - fZ);


