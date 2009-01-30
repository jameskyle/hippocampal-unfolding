function imgStruct = ...
    mrVolChangeImage(volStruct, displayStruct, grayStruct, layer1Struct, selectedNode, displayData, cutNodes, mVoxelsStruct, h_fig2)
% 
% imgStruct = ...
%   mrVolChangeImage(volStruct, displayStruct, grayStruct, layer1Struct, selectedNode, displayData, cutNodes, mVoxelsStruct, h_fig2)
% 
% AUTHOR:  Wandell
% DATE:    03.09.97
% PURPOSE:
%   Part of mrVolWindow callback.  Update the image number
% and display the new image
% HISTORY: 03.18.97 ABP  Added other orientations.
%	   03.25.97 ABP  Added geoLineIndices
%	   12.12.97 SJC  Converted variables to structures
%	   05.25.98 SJC  Made a separate structure for selectedNode
%	   07.10.98 SJC	 Added displayData as an input parameter
%			 Added a call to mrOverlayData for displaying
%			 data loaded in and overlaid over the gray matter
%	   07.13.98 SJC  Added a warning message because function has 
%			 been renamed mrChangeImage.
%


disp('Warning:  mrVolChangeImage is obsolete.  Please call mrChangeImage instead.');

% As of 07.10.98:
%
% These are the input/output parameters for mrOverlayDist with all gray matter points
% [selectedNode, displayStruct.flags(3), imgStruct] = ...
%	mrOverlayDist(volStruct,displayStruct,grayStruct,selectedNode,cutNodes,mVoxelsStruct,h_fig2);
%
% These are the input/output parameters for mrOverlayDist with only first layer gray matter points
% [selectedNode, displayStruct.flags(3), imgStruct] = ...
%	mrOverlayDist(volStruct,displayStruct,layer1Struct,selectedNode,cutNodes,mVoxelsStruct,h_fig2);
%
% These are the input/output parameters for mr

if displayStruct.flags(1) == 1 			% showDistance flag
  mrVolOverlayAllGrayDistScript;
        						
elseif displayStruct.flags(2) == 1 		% showGray flag
  [displayStruct.flags(2),imgStruct] = mrVolOverlayGray(volStruct,displayStruct,grayStruct.nodes(1:3,:),-1,cutNodes,mVoxelsStruct,h_fig2);
  
elseif displayStruct.flags(3) == 1		% showCut flag
  if ~isempty(layer1Struct.nodes)
    mrVolOverlayLayer1DistScript;
  else
    mrVolOverlayAllGrayDistScript;
  end
  
elseif displayStruct.flags(5) == 1
  [displayStruct.flag(5),imgStruct] = mrOverlayData(...
	  				volStruct,displayStruct,grayStruct,displayData,cutNodes,mVoxelsStruct,h_fig2);
else
  imgStruct = mrVolShowImage(volStruct.vData,volStruct.vSize,displayStruct,h_fig2);
end

return;


