function w = makeSemiCircularWindow(fcn1d,nx,ny,nt,shiftStep,direction,orientation)
%
%	w = makeSemiCircularWindow(fcn1d,nx,ny,nt,shiftStep,direction)
%
%AUTHOR:  Engel, Wandell
%DATE:  1.10.95
%PURPOSE:
%  Make a circular window that we use in the expanding rings style
%  experiment.
%
%  fcn1d:  the 1d function describing t window as a function of
%          distance from the center of the image.
%  w:      the returned set of windowing functions.  Each column is a
%  window whose size is (nx,ny), and there are nt columns.
%  shiftStep:  The number of locations to rotate the fcn1d 
%	when we create the stimulus 
%  direction:  'r' [default} or 'l' that determines the motion of the
%   window as outward or inward.
%
%  We can create a windowed stimulus by taking an image and
%  calculating:
%
%	for i=1:nt
%         ithImage = window(:,i) .* stimulus
%	end


if nargin < 4
 error('makeCircularWindow:  needs fcn1d, nx,ny, and nt ')
elseif nargin < 5
 direction = 'r';
 shiftStep = 1;
elseif nargin < 6
 direction = 'r';
elseif nargin < 7
 orientation = 'u';
elseif nargin > 8
  error('makeCircularWindow:  too many arguments')
end
 
% Make a matrix that contains the distance from the center
% for each point in the [nx,ny] grid.
%
[xdistances ydistances] = meshgrid(1:nx,1:ny);
xdistances = xdistances - (nx/2);
ydistances = ydistances;
if (orientation == 'd');
  ydistances = flipud(ydistances);
end
r = sqrt(xdistances.^2 + ydistances.^2);
corner = find(r > min(nx/2,ny));
r(corner) = zeros(1,length(corner));
qr = setQuantization(r,length(fcn1d));

disp('Making zero-matrix ');
w = zeros(nx*ny,nt);
z = zeros(length(corner),1);
disp('Done making zero-matrix ');
rotlocs = 0:(length(fcn1d)-1);
dubfcn = [fcn1d fcn1d];
dublocs = 1:length(dubfcn);
for t=1:nt
 disp(t);
 rotfcn1d = interp1(dublocs, dubfcn, rotlocs+1);
 rotlocs = rotlocs+shiftStep;
 rotlocs = mod(rotlocs,length(fcn1d));
 w(:,t) = rotfcn1d(qr);
 w(corner,t) = z;
end

% fcn1d = vecRotate(fcn1d,shiftStep,direction);
% w(:,t) = reshape(fcn1d(floor(distances) + 1),nx*ny,1);
