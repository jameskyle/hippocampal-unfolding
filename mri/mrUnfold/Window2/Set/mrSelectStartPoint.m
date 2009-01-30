function [selectedNode,imgStruct] = mrSelectStartPoint(volStruct,displayStruct,nodes,h_fig2)
% 
%       [selectedNode,imgStruct] = mrSelectStartPoint(volStruct,displayStruct,nodes,h_fig2)
% 
% AUTHOR: Wandell
% DATE:   03.10.97
% PURPOSE:
%   Find the x,y positions of the nodes within the desired plane
% HISTORY: 03.17.97 ABP -- Added slice orientations
%          11.13.97 SJC -- Fixed coronal node orientation to work with 3D matrix

layer1 = find(nodes(6,:) == 1);

switch displayStruct.activeSliceOri

  case 1,			% SAGITTAL grayNode indices
	grayNodeIndex = 3;
	% Find the list of locations in the desired image.
	l = intersect(find(nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri)),layer1);
	if isempty(l)
	  disp('ERROR: No first layer gray matter in this slice.');
	  selectedNode.index = -1;
	  imgStruct = [];
	  return;
	end
	x = nodes(1,l); y  = nodes(2,l);
	
  case 2,			% AXIAL
	grayNodeIndex = 2;
	l = intersect(find(nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri)),layer1);
	if isempty(l)
	  disp('ERROR: No first layer gray matter in this slice.');
	  selectedNode.index = -1;
	  imgStruct = [];
	  return;
	end
	x = nodes(1,l); y = nodes(3,l); 

  case 3,			% CORONAL 
	grayNodeIndex = 1;
	l = intersect(find(nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri)),layer1);
	if isempty(l)
	  fdisp('ERROR: No first layer gray matter in this slice.');
	  selectedNode.index = -1;
	  imgStruct = [];
	  return;
	end
	x = nodes(2,l); y = nodes(3,l);
	 
  otherwise,
	disp('ERROR mrVolSelect:  Invalid slice orientations');
	selectedNode.index = -1;
	imgStruct = mrVolShowImage([],[volStruct.vSize(displayStruct.activeSliceOri,1:2) 1], displayStruct,h_fig2);
	return;
end

% Show the gray matter locations
tmpImage = ExtractVolImage(volStruct.vData,volStruct.vSize,displayStruct);
tmpImage = reshape(tmpImage,volStruct.vSize(displayStruct.activeSliceOri,1),volStruct.vSize(displayStruct.activeSliceOri,2));

for ii = 1:length(l)
  tmpImage(y(ii),x(ii)) = -1;
end
mrVolShowImage(tmpImage(:),[volStruct.vSize(displayStruct.activeSliceOri,1:2) 1], displayStruct,h_fig2);

% Let the user click and find out the nearest location 
%
fprintf('Click to select gray matter point\n');

% Find the closest gray-matter point
% 
[c r] = ginput(1);
c = round(c); r = round(r);

if (displayStruct.activeSliceOri ~= 1)
  temp = c;
  c = r;
  r = temp;
end

% Figure out the closest x,y to the c,r and set its value in the
% color map.
% 
[v idx] = min(abs(x - c) + abs( y - r));
selectedX = x(idx);
selectedY = y(idx);
selectedZ = displayStruct.iNumber(displayStruct.activeSliceOri); 

% Let the user see what was selected
% 
tmpImage(selectedY, selectedX) = -2;
imgStruct = mrVolShowImage(tmpImage(:),[volStruct.vSize(displayStruct.activeSliceOri,1:2) 1], displayStruct,h_fig2);

% Now, convert the point into an index in the gray-matter
% graph. This is what should be used by the unfolding code.
% 
selectedNode.index = l(idx);

% 'selectedNode' is actually a column number in 'grayNodes'
selectedNode.S = nodes(3,selectedNode.index);
selectedNode.A = nodes(2,selectedNode.index);
selectedNode.C = nodes(1,selectedNode.index);

return;








