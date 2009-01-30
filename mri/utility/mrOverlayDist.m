function [selectedNode, showDistance, imgStruct] = ...
		    mrOverlayDist(volStruct,displayStruct,...
				    grayStruct,selectedNode,cutNodes,mVoxelsStruct,h_fig2) 
% 
% [grayStruct,showDistance,imgStruct] = mrOverlayDist(volStruct,displayStruct,...
%							grayStruct,cutNodes,mVoxelsStruct,h_fig2) 
% AUTHOR:  Wandell
% DATE:    03.10.97
% PURPOSE:
%   Show the overlaid gray matter in a color that measures that
% distance from the currently selected node
%
% HISTORY:
% 03.18.97 ABP	Added slice orientations
% 11.22.97 SJC	Added show cut
% 12.12.97 SJC	Converted variables to structures
% 05.25.98 SJC	Made a separate structure for selectedNode
% 07.10.98 SJC	Changed name from mrVolOverlayDist.m to mrOverlayDist.m
%

% Set up display flags
% 
showDistance = 1;

% Find the distance from the selected node to other gray nodes
% 
noVol = -1;
if (selectedNode.index < 1)
  [selectedNode.index, imgStruct] = mrSelectStartPoint(volStruct,displayStruct,grayStruct.nodes,h_fig2);
  if (selectedNode.index == -1)
    disp('ERROR:  Node not selected.')
    [showGray,imgStruct] = mrOverlayGray(volStruct,displayStruct,grayStruct.nodes(1:3,:),[],cutNodes,mVoxelsStruct,h_fig2);
    return;
  end
end
grayStruct.dist = mrManDist(grayStruct.nodes,grayStruct.edges,selectedNode.index,volStruct.dimdist,noVol,volStruct.radius);

switch displayStruct.activeSliceOri
  case 1,			% Sagittal grayNode indices
	grayNodeIndex = 3;
  case 2,			% Axial
	grayNodeIndex = 2;
  case 3,			% Coronal 
	grayNodeIndex = 1;
  otherwise,
	disp('ERROR mrOverlayDist:  Invalid slice orientations');
	return;
end

% Find the list of locations in the desired image.
inPlaneList = find(grayStruct.nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri));

% Find the gray matter in the current image plane
l = find(grayStruct.dist(inPlaneList) > noVol);

% Set all the gray matter points to either a highlight color or
% to the distance color
% 
grayColorOverlay = -5*ones(1,length(inPlaneList));

% The distances run from 0 to radius.  So, we scale the distances
% so that they may from 0 to 63, the number of color map entries
% devoted to coding distance.
% 
grayColorOverlay(l) = -1*round(grayStruct.dist(inPlaneList(l))*(63/volStruct.radius) + 6);

% Call the basic overlay routine
% NOTE: 'showGray' flag never used.  
% Here as placeholder for correct return of other values.
[showGray,imgStruct] = mrOverlayGray(volStruct,displayStruct,grayStruct.nodes(1:3,:),grayColorOverlay,cutNodes,mVoxelsStruct,h_fig2);

% Initially, distances are not calculated for points outside of the unfold radius for display purposes, but now
% the distances for all points are calculated.
grayStruct.dist = mrManDist(grayStruct.nodes,grayStruct.edges,selectedNode.index,volStruct.dimdist,noVol);

return;




