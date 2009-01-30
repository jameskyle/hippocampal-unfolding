function figNum = trueShow(target, map, figNum)
% trueShow(X,map) 
%	Displays the image matrix using the given colormap map by 
%	resizing the xwindow and axes object within the window to fit 
%	the image exactly.  The resultant window is not resizeable.  
%	If the maximum value of Xis less than 1 then we assume 
%	that all values are in [0,1] and we rescale according to the 
%	size of the colormap.
%
%	See Matlab Reference Guide "figure:MinColorMap".
%	Questions, comments, insults to Dan Lee (dslee@white.stanford.edu)
%
% Functions called
%	scale()
%
% Dan Lee
% 6/30/93

tol = 1e-5;

% if no colormap is given then make the image black and white.
if nargin < 2, map = [0 0 0; 1 1 1]; end
if nargin < 3, figNum = 1000; end

% if the max is less than 1 then we assume that the image has
%  values between 0 and 1 inclusive and we rescale to the colormap.
if max(max(target)) <= 1+tol
	target = scale(target,1,size(map,1),0,1);
end

% make a new window and show image in window.
figNum = figure(figNum);
image(target);
colormap(map);

% resize window so we have enough room for image.
[row,col] = size(target);
rect = get(figNum,'Position');
set(figNum, 'Position', [rect(1), rect(2), col, row]);
set(figNum, 'Resize','off');

% resize axes of the image so it fits the axes perfectly.
ha = gca;
set(ha, 'Units', 'pixels');
axis off;
set(ha, 'Position', [1, 1, col, row]);










