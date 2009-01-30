function w = wedgeWindow(angFunc,nx,ny,nt,shiftStep,direction)
%
%	w = wedgeWindow(angFunc,nx,ny,nt,shiftStep,direction)
%
%AUTHOR:  Wandell
%DATE:  5.27.95
%PURPOSE:
%  Make a wedge window that we use in the rotating wedge style
%  experiment.
%
%  angFunc:    A function ranging from 0 to 2 pi that defines which angles
%	       are turned on and which are turned off.
%  nx,ny,nt:   The x,y and t dimensions of the windowing functions
%  shiftStep:  The number of locations to shift the angFunc at each step.
%  direction:  'r' [default} or 'l' that determines the motion of the
%              window as clockwise or counter-clockwise.
%
%  w:          A of binary windows used to mask the image.  Each column is a
%              window whose size is (nx,ny), and there are nt columns.  1 means
%              pass this data point, 0 means occlude it.
%
%  Create a windowed stimulus by taking an image sequence and calculating:
%
%	for i=1:nt
%         ithImage = window(:,i) .* stimulus(:,i)
%	end

%angFunc = [ones(1,16) zeros(1,16) ones(1,16) zeros(1,16) ...
%	   ones(1,16) zeros(1,16) ones(1,16) zeros(1,16)];
%nx = 128, ny = 128, nt = 32;
%shiftStep = 1;
%direction = 'r';

if nargin < 4
 error('makeWedgeWindow:  needs angFunc, nx,ny, and nt ')
elseif nargin < 5
 direction = 'r';
 shiftStep = 1;
elseif nargin < 6
 direction = 'r';
elseif nargin > 7
  error('makeWedgeWindow:  too many arguments')
end
 
% Make a matrix that contains the angle relative to the center
% for each point in the [nx,ny] grid.
%
[xdistances ydistances] = meshgrid(1:nx,1:ny);
xdistances = xdistances - (nx/2);
ydistances = ydistances - (ny/2);
%distances = sqrt(xdistances.^2 + ydistances.^2);
ang = atan2(ydistances,xdistances);

%imagesc(ang), colormap(gray(64)), brighten(0.7)
%imagesc(distances), brighten(0.5)

%  Map the angles into the same number of levels as in angFunc
%
nAng = length(angFunc);
inAngles = scale(1:nAng,-pi, pi);
qAng = setQuantization(ang,nAng);
%imagesc(qAng), colormap(gray(64)), brighten(0.7)

% Get ready to rotate the current angles around
%
currentAngFunc = angFunc;
w = zeros(nx*ny,nt);
for i=1:nt
 w(:,i) = currentAngFunc(qAng)';
 currentAngFunc = vecRotate(angFunc,round(i*shiftStep),direction); 
 sprintf('Image %d',i)
end

