function cmap = cmapRotate(mp,nSteps,direction)
%
% 	cmap = cmapRotate(mp,nSteps,direction)
%
%AUTHOR:  Wandell
%DATE:  April 24, 1995
%PURPOSE:
%	Rotate a color map circularly.  This is useful for making more
%	pleasing versions of circular maps, such as the hsv map.
%	
%	mp:  The color map
%	nSteps:  The number of steps to rotate the map
%       direction: 'l','L' rotate left [DEFAULT]
%                  'r','R' rotate right
%HISTORY:  03.12.97 ABP -- Added direction argument.
% 

if (nargin < 3)
  direction = 'l';
end

for i=1:3
  cmap(:,i) = vecRotate(mp(:,i),nSteps,direction);
end

