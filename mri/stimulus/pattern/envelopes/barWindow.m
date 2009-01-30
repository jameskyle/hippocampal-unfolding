function w = barWindow(fcn1d,nx,ny,nt,shiftStep,direction)
%
%	w = makeCircularWindow(fcn1d,nx,ny,nt,shiftStep,direction)
%
%AUTHOR:  Engel, Wandell
%DATE:  1.10.95
%PURPOSE:
%  Make a vertical window that we use in the moving bars style
%  experiment.
%
%  fcn1d:  the 1d function describing t window as a function of
%          x distance from the center of the image.
%  w:      the returned set of windowing functions.  Each column is a
%  window whose size is (nx,ny), and there are nt columns.
%  shiftStep:  The number of locations to rotate the fcn1d 
%	when we create the stimulus 
%  direction:  'r' [default} or 'l' that determines the motion of the
%   window as left or right
%
%  We can create a windowed stimulus by taking an image and
%  calculating:
%
%	for i=1:nt
%         ithImage = window(:,i) .* stimulus
%	end


if nargin < 4
 error('barWindow:  needs fcn1d, nx,ny, and nt ')
elseif nargin < 5
 direction = 'r';
 shiftStep = 1;
elseif nargin < 6
 direction = 'r';
elseif nargin > 7
  error('barWindow:  too many arguments')
end
 
% Make a matrix that contains the distance from the center
% for each point in the [nx,ny] grid.
%
[xdistances ydistances] = meshgrid(1:nx,1:ny);
xdistances = xdistances - (nx/2);
qx = setQuantization(xdistances(:),length(fcn1d));

disp('Making zero-matrix ');
w = zeros(nx*ny,nt);
disp('Done making zero-matrix ');
rotlocs = 0:(length(fcn1d)-1);
dubfcn = [fcn1d fcn1d];
dublocs = 1:length(dubfcn);
for t=1:nt
 disp(t);
 rotfcn1d = interp1(dublocs, dubfcn, rotlocs+1);
 rotlocs = rotlocs+shiftStep;
 rotlocs = mod(rotlocs,length(fcn1d));
 w(:,t) = rotfcn1d(qx);
end

