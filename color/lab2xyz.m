function xyz = lab2xyz(lab,white)
%  xyz = lab2xyz(lab,white)
%
%    Return the xyz values from a set of La*b* values.
%    lab is a 3 x N matrix of Lab values
%    white is 3 vector specifying the white point
%
if length(white) ~= 3,
  error('White point is not a three-vector');
elseif size(lab,1) ~= 3,
  error('lab argument must have three rows');
end

Lstar = lab(1,:);
astar = lab(2,:);
bstar = lab(3,:);

Xn = white(1);
Yn = white(2);
Zn = white(3);


%
%	Allocate space
%
fX = zeros(1,size(lab,2));
fY = zeros(1,size(lab,2));
fZ = zeros(1,size(lab,2));

Xratio = zeros(1,size(lab,2));
Yratio = zeros(1,size(lab,2));
Zratio = zeros(1,size(lab,2));


% Usual formula for Lstar
Y = Yn .*  ( (Lstar + 16.0) ./ 116.0) .^ 3.0;

% but if Y/Yn is too small, use other formula
l = (Y/Yn) < 0.008856;
Y(l) =  (Lstar(l) / 903.3) * Yn;
%
%	Now, we estimate X/Xn, Y/Yn, and Z/Zn
%
Yratio = (Y/Yn);
l = Yratio > .008856;
fY(l) = Yratio(l).^(1/3);
fY(1-l) = 7.787 * Yratio(1-l) + 16/116;


% Inverse range for Lab ratios
fX = (astar/500.0) + fY;
l = fX > 0.206893;
Xratio(l) = fX(l) .^ 3;
Xratio(1-l) = (fX(1-l) - (16/116)) / 7.787;

% Inverse range for Lab ratios
fZ = fY - (bstar/200.0);
l = fZ > 0.206893;
Zratio(l) = fZ(l) .^ 3;
Zratio(1-l) = (fZ(1-l) - (16/116)) / 7.787;


%	Finally, we deduce X, Y and Z
X = Xratio * Xn;
Z = Zratio * Zn;

xyz = [X;Y;Z];

