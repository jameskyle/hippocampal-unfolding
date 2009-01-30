function [showData, imgStruct] = mrVolOverlayData(volStruct,displayStruct,...
				grayStruct,displayData,cutNodes,mVoxelsStruct,h_fig2) 
% 
% function [showData, imgStruct] = mrVolOverlayData(volStruct,displayStruct,...
%				grayStruct,displayData,cutNodes,mVoxelsStruct,h_fig2) 
% AUTHOR:  SJC
% DATE:    07.09.97
% PURPOSE:	Show the data at the specified x,y,z locations overlaid
%   		on the gray matter.  Modified code from mrVolOverlayDist.m
%


% Set up display flags
% 
showData = 1;

% Find view orientation
%
switch displayStruct.activeSliceOri
  case 1,			% Sagittal
	grayNodeIndex = 3;
  case 2,			% Axial
	grayNodeIndex = 2;
  case 3,			% Coronal 
	grayNodeIndex = 1;
  otherwise,
	disp('ERROR mrVolOverlayGray:  Invalid slice orientations');
	return;
end

% Find the list of gray matter locations in the desired image
inPlaneGrayList = find(grayStruct.nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri));

% Find the list of data point locations in the desired image
[dummy inPlaneDataList dataIdx] = intersect(inPlaneGrayList,displayData(:,5));

% Set all the gray matter points to either a highlight color
% 
grayColorOverlay = -5*ones(1,length(inPlaneGrayList));

% Overlay the colormap index on the data point locations
% 
grayColorOverlay(inPlaneDataList) = -1*(displayData(dataIdx,4) + 70);

% Call the basic overlay routine
% NOTE: 'showGray' flag never used.  
% Here as placeholder for correct return of other values.
[showGray,imgStruct] = mrVolOverlayGray(volStruct,displayStruct,grayStruct.nodes(1:3,:),...
			grayColorOverlay,cutNodes,mVoxelsStruct,h_fig2);

return;
