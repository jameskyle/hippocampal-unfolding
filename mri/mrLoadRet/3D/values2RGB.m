function xyz_RGBAlpha = values2RGB(xyz_amp_co_ph_dc,data_selected,scanNum,...
              noDataVal,coThresh,pWindow)
% function xyz_RGBAlpha = values2RGB(xyz_amp_co_ph_dc,data_selected,scanNum,...
%             noDataVal,coThresh,pWindow)
%
% AUTHOR: SJC, ABP
% DATE: 04.07.98
% PURPOSE:
%	To create a matrix of (x,y,z) locations and R,G,B values for rendering
%	each of those points out of the data selected
% ARGUMENTS:
%	xyz_amp_co_ph_dc:	[x, y, z, amp, co, ph, dc]
%				matrix contains the layer 1 point locations
%				and the averaged amplitude, phase, correlation
%				and dc values at each point
%	data_selected:		can be 'amp', 'co', 'ph', or 'dc', depending
%				on which data the user wishes to render
%	scanNum:		from which scan you want to extract data
%	noDataVal:		value for points with no fMRI data
%	                        (DEFAULT = -99)
%	coThresh:		correlation threshold required
%	                        for displaying data. (DEFAULT = 0.23)
%	pWindow:		phase window threshold required
%	                        for displaying data. (DEFAULT = [0 360])
%	                        
% RETURNS:
%	xyz_RGBAlpha:		[x, y, z, R, G, B, Alpha]
%				matrix contains the layer 1 point locations
%				and the RGB and Alpha values for rendering 
%				each of those points

grayCmapVal  = 128;
alphaCmapVal = 255;
maxCmapVal = 255;
 
maxCmapIdx = 256;

if nargin < 6
  pWindow = [0 360];
end
if nargin < 5
  coThresh = 0.23;
end
if nargin < 4
  noDataVal = -99;
end
if nargin < 3
  disp(sprintf('values2RGB:  Too few arguments passed'))
end

% Convert phase values to radians
pWindow = pWindow*(pi/180);

if scanNum > size(xyz_amp_co_ph_dc,3)
    disp(sprintf('values2RGB:  Asking for scan %d out of %d',...
	  scanNum,size(xyz_amp_co_ph_dc,3)));
end

% Find which data set user has selected
switch data_selected
  case 'amp',
    dataCol = 4;
  case 'co', 
    dataCol = 5;
  case 'ph', 
    dataCol = 6;
  case 'dc', 
    dataCol = 7;
  otherwise,
    disp('values2RGB: Invalid data selection, data_selected must be one of:');
    disp(' ''amp'', ''co'', ''ph'' or ''dc''');
    return;
end

% Initialize output matrix to gray for all points
% [x,y,z,r,g,b,alpha]
xyz_RGBAlpha = grayCmapVal * ones(size(xyz_amp_co_ph_dc,1),7);

% Assign values to x,y,z locations
xyz_RGBAlpha(:,1:3) = xyz_amp_co_ph_dc(:,1:3,scanNum);

% Assign Alpha values (constant for right now)
xyz_RGBAlpha(:,7) = alphaCmapVal * ones(size(xyz_amp_co_ph_dc,1),1);

% Extract the data column the user requested
measCol = xyz_amp_co_ph_dc(:,dataCol,scanNum);

% Find all points that contain data in this column
dataPoints = find(measCol ~= noDataVal);

% Find all correlation points above coThresh
coPoints = find(xyz_amp_co_ph_dc(dataPoints,5,scanNum) >= coThresh);

% Find all phase points within pWindow
phPoints = find((xyz_amp_co_ph_dc(dataPoints,6,scanNum) >= pWindow(1)) & ...
                (xyz_amp_co_ph_dc(dataPoints,6,scanNum) <= pWindow(2)));
    
% Find all data points that pass both phase and correlation tests
displayPoints = dataPoints(intersect(coPoints,phPoints));

% Set cmap to red/green. Reset if we have phase data
% This is the essence in the routine 'mrRedGreenCmap'.  
cmap = zeros(maxCmapIdx,3); 
for i = 1:maxCmapIdx

  cmap(i,:) = round(maxCmapVal*[i/maxCmapIdx, (maxCmapIdx-i)/maxCmapIdx, 0]);
end

% Assign max/min range value
switch data_selected
  case 'amp',            % floating high end of range
    minData = 0;         % mrLoadRet-1.0 fixes minimum amplitude  to 0.0
    maxData = max(measCol(displayPoints));
  case 'co',             % floating range
    minData = min(measCol(displayPoints));
    maxData = max(measCol(displayPoints));
  case 'ph',             % fixed range
    minData = 0.0;
    maxData = 2*pi;
    cmap = round(maxCmapVal*hsv(maxCmapIdx));
  case 'dc',             % floating range
    minData = min(measCol(displayPoints));
    maxData = max(measCol(displayPoints));
end

% Make an index into the colormap
% .) Force data into range 0-1 
% .) Force into range 1-maxCmapIdx
% .) This gives us an index into the colormap, which we use to 
%    assign an [r,g,b] color to the [x,y,z] location
cmapIdx = round((maxCmapIdx -1) * ...
                (measCol(displayPoints)-minData)./(maxData-minData)) + 1;

% Assign the R,G,B values
xyz_RGBAlpha(displayPoints,4:6) = cmap(cmapIdx,:);

return;

