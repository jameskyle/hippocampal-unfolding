function xyz = luv2xyz(luv,whitePoint)
%  xyz = luv2xyz(luv,whitePoint)
%
%    Return the xyz values from a set of La*b* values.
%    luv is a 3 x N matrix of Luv values
%    whitePoint is 3 vector specifying the white point
%
if length(whitePoint) ~= 3
  error('White point is not a three-vector')
elseif size(luv,1) ~= 3
  error('luv argument must have three rows')
end

%	Compute un and vn from Xn,Yn,Zn
Xn = whitePoint(1);  Yn = whitePoint(2); Zn = whitePoint(3);
un = 4.0*Xn / (Xn + 15.0*Yn + 3.0*Zn);
vn = 9.0*Yn / (Xn + 15.0*Yn + 3.0*Zn);

% Usual formula for Lstar
Lstar = luv(1,:);
Y = Yn .*  ( (Lstar + 16.0) ./ 116.0) .^ 3.0;
l = (Y/Yn) < 0.008856;          % if Y/Yn is too small, use other formula
Y(l) =  (Lstar(l) / 903.3) * Yn;

ustar = luv(2,:);
vstar = luv(3,:);

u = ( ustar ./ (13.0 * Lstar ) ) + un;
v = ( vstar ./ (13.0 * Lstar ) ) + vn;

X = (9.0/4.0)* (u ./ v) .*  Y;
Z = ( ((4.0*ones(size(u)) - u) .* X) ./ (3.0 * u) ) - (5.0*ones(size(Y)) .* Y);

xyz = [X;Y;Z];

