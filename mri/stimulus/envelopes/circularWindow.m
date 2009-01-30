function w = circularWindow(parms,radFunc,shiftStep)
%
%	w = circularWindow(parms,radFunc,shiftStep)
%
%AUTHOR:  Engel, Wandell
%DATE:  1.10.95
%PURPOSE:
%  Make a circular window that we use in the expanding rings style
%  experiment.
%
%  radFcn:  the 1d function describing t window as a function of
%          distance from the center of the image.
%  shiftStep:  The number of locations to rotate the radFcn 
%	when we create the stimulus 
%
%  w:  the returned set of windowing functions.  Each column is a
%  window whose size is (nx,ny), and there are nt columns.
%
%  We apply the window to a space-time stimulus by 
%
%	for i=1:nt
%         ithImage = window(:,i) .* stimulus
%	end

% parms = [32 32 32];
% shiftStep = -1;
% radFunc = square(2*pi*2*[0.05:.05:1]);

if nargin < 3
 shiftStep = 1;
end
if nargin < 2
  error('circularWindow:  Not enough arguments')
end
 
nx = parms(1); ny = parms(2);
nt = parms(3);

% Make a matrix that contains the distance from the center
% for each point in the [nx,ny] grid.
%
nRad = length(radFunc);
[xdistances ydistances] = meshgrid(1:nx,1:ny);
xdistances = xdistances - (nx/2);
ydistances = ydistances - (ny/2);
r = sqrt(xdistances.^2 + ydistances.^2);
qr = setQuantization(r,nRad);

w = zeros(nx*ny,nt);
currentRadFunc = radFunc;
for i=1:nt
 w(:,i) = currentRadFunc(qr)';
 currentRadFunc = vecRotate(radFunc,round(i*shiftStep)); 
end

%displayMovie(w,nx,ny,nt,1,.2,'s')
