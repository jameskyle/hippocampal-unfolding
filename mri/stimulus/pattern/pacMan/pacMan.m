function pman = pacman(radius,minAngle,maxAngle)
%
%   function pman = pacman(radius,minAngle,maxAngle)
%
%	radius: the radius of the pacman circle
%	maxAngle and minAngle define the region that is black.
%
%AUTHOR:  Boynton and Wandell
%DATE:    01.19.95
%PURPOSE:
%
%	Draw a pacman figure and return it in a matrix.  The values
%	instead the pacman are set equal to 1, and the values outside
%	the pacman are set equal to zero.
%

%radius = 64;
%maxAngle = pi/6;
%minAngle = 0;

x = [-radius:radius];
y = [-radius:radius];
[X Y] = meshgrid(x,y);

pman = zeros(size(X));
inPac = find ( ~(atan2(Y,X) >= minAngle & atan2(Y,X) <= maxAngle ) & ...
              X.^2 + Y.^2 <= radius^2 & ...
              ~(X == 0 & Y == 0));
pman = pman(:);
pman(inPac) = ones(size(inPac));
pman = reshape(pman,size(X,1),size(X,2));


%imagesc(pman), axis image, axis on

