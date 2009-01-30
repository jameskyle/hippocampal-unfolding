function img=insertFixation(img,fixColor,backColor,fixWidth,hLoc,vLoc)
%
%    img=insertFixation(img,fixColor,backColor,fixWidth)
%
%
%AUTHOR:  Wandell
%PURPOSE: Insert a fixation mark into an image
%DATE:    05.25.95
%
% img:  	The original input image, which is modified
% fixColor:  Color table value for fixation line
% backColor: Color table value for non-line part of fixation
% fixWidth:  The row and col dimensions of the fixation square.
%	


% img = rand(32,32);
% fixColor = 5;
% backColor = 1;
% fixWidth = 5;

if (size(img,1)==1 | size(img,2)==1)
 error('insertFixation: first argument must be image matrix');
end

[m n] = size(img);

% Set up defaults
if nargin < 6
 hLoc = m/2;
end
if nargin < 5
 vLoc = n/2;
end
if nargin < 4
 fixWidth = 4;
end
if nargin < 3
 backColor=127.5;
end
if nargin < 2
 fixColor=255;
end
if nargin < 1
 error('Wrong number of arguments to insertFixation')
end

% Width of fixation point (try 6)
[x,y]= meshgrid([1: fixWidth],[1: fixWidth]);

% Draw the fixation square.  First, set it all to the background color.
fix = backColor * ones(size(x));

% Then set the edges of the square to the fixation color
fix(1,:) = ones(1,fixWidth)*fixColor;
fix(fixWidth,:) = ones(1,fixWidth)*fixColor;
fix(:,1) = ones(fixWidth,1)*fixColor;
fix(:, fixWidth) = ones(fixWidth,1)*fixColor;

% Now, copy the data in fix into the central location of img
hLoc = (hLoc - fixWidth/2);
vLoc = (vLoc - fixWidth/2);
img(hLoc:(hLoc+fixWidth-1),vLoc:(vLoc+fixWidth-1)) = fix;








