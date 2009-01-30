function [showGray,imgStruct] = ...
    mrOverlayGray(volStruct,displayStruct,nodeXYZ,grayColorOverlay,cutNodes,mVoxelsStruct,h_fig2)
% 
%   [showGray,imgStruct] = mrOverlayGray(volStruct,displayStruct,nodeXYZ,grayColorOverlay,cutNodes,mVoxelsStruct,h_fig2)
% 
% AUTHOR: Wandell
% DATE: 03.09.97
% PURPOSE: 
%   Show the gray matter overlaid on the current volume anatomy image. 
% HISTORY: 03.18.97 ABP -- Added different slice orientations.
%	   03.25.97 ABP -- geoLineIndices
%          11.13.97 SJC -- Fixed coronal node orientation to work with 3D matrix
%	   12.12.97 SJC -- Converted variables to structures
%	   02.03.98 SJC, BW -- Replaced for-loops to speed up code
%	   03.26.98 SJC -- Commented out the code that does not allow the display
%			   of a slice with no gray matter in it
%	   07.13.98 SJC -- changed name of function from mrVolOverlayGray
%			   to mrOverlayGray
%

% Set display flag on
% 
showGray = 1;
 
% Check arguments
% 
if (~exist('grayColorOverlay') | isempty(grayColorOverlay))
  grayColorOverlay = -1;
end

if (displayStruct.activeSliceOri == 1)		% Sagittal grayNode indices
	grayNodeIndex = 3;
elseif (displayStruct.activeSliceOri == 2)	% Axial
	grayNodeIndex = 2;
elseif (displayStruct.activeSliceOri == 3)	% Coronal 
	grayNodeIndex = 1;
else
	disp('ERROR mrVolOverlayGray:  Invalid slice orientations');
	return;
end

% Find the indeces in 'grayNodes' for graymatter locations in this plane
l = find(nodeXYZ(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri));

% 03.26.98 -- SJC
% The following code checks to see if there is any gray matter in the current slice
% If there isn't any, it tells the user in which slices there is gray matter and
% does not display any slices without gray matter in them.  The code has been
% commented out so that the user will be able to traverse through slices that do
% not have any gray matter in them.

% If there is none there, tell the person where they are,  
% then return to the main loop
% 
%if length(l) == 0
%  fprintf('No gray matter in image %3.0f\n',displayStruct.iNumber(displayStruct.activeSliceOri))
%  fprintf('   Gray matter in images:\n');
%  for ii = 1:volStruct.vSize(displayStruct.activeSliceOri,3)
%    l = find(nodeXYZ(grayNodeIndex,:) == ii);
%    if length(l) > 0
%      fprintf('%3.0f ',ii);
%    end
%  end
%  fprintf('\n');
%  return;
%end

if (length(l) > 0)
  % Find their x y locations in this image
  if (displayStruct.activeSliceOri == 1)		% SAGITTAL
	x = nodeXYZ(1,l); y  = nodeXYZ(2,l);
  elseif (displayStruct.activeSliceOri == 2)		% AXIAL
	x = nodeXYZ(1,l); y = nodeXYZ(3,l); 
  elseif (displayStruct.activeSliceOri == 3)		% CORONAL 
	x = nodeXYZ(2,l); y = nodeXYZ(3,l); 
  end
else
  x = [];
  y = [];
  fprintf('\nNo gray matter in this slice.\n');
end

% Create a display image with the gray matter point locations
% identified in an overlay color
% 
tmpImage = ExtractVolImage(volStruct.vData,volStruct.vSize,displayStruct);
tmpImage = reshape(tmpImage,volStruct.vSize(displayStruct.activeSliceOri,1),volStruct.vSize(displayStruct.activeSliceOri,2));

% If there is gray matter in this slice, show the gray matter,
% cuts, and marked voxels
%
if (~isempty(x) & ~isempty(y))
  % Overlay uniform gray matter, or the distance 
  tmpImage = replaceLocs(tmpImage,y,x,grayColorOverlay);

  % Show cut in this slice
  if (displayStruct.flags(3) == 1)
    % 'l' is list of 3d node indices which are in this plane
    % 'cutNodes' is the list of grayNode indices which are between
    % the selected points in the 3D volume.
    % We want to find what bit of that 3D line is in this plane

    tmpImage = mrShowNodes(tmpImage,l,cutNodes,x,y,-1);
  end

  % Show marked voxels in this slice
  if (displayStruct.flags(4) == 1)

    tmpImage = mrShowNodes(tmpImage,l,mVoxelsStruct.Area1,x,y,-2);
  
    tmpImage = mrShowNodes(tmpImage,l,mVoxelsStruct.Area2,x,y,-3);
  
    tmpImage = mrShowNodes(tmpImage,l,mVoxelsStruct.Area3,x,y,-4);
  
    tmpImage = mrShowNodes(tmpImage,l,mVoxelsStruct.Area4,x,y,-5);
  
    tmpImage = mrShowNodes(tmpImage,l,mVoxelsStruct.Area5,x,y,-6);
  
    tmpImage = mrShowNodes(tmpImage,l,mVoxelsStruct.Area6,x,y,-7);
    
  end
end

% Display the image with overlay, tricking mrVolShowimage a bit by
% sending in this dummy structure
% 
imgStruct = mrVolShowImage(tmpImage(:),[volStruct.vSize(displayStruct.activeSliceOri,1:2) 1],displayStruct,h_fig2);

return;




