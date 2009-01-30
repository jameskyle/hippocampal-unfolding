% script 
% 
%      mrUnfold
% 
% AUTHOR:  Boynton, Wandell
% DATE:    March 3, 1997
% PURPOSE:
%  Page through a set of images in a vAnatomy file and select a
%  single point.  The left button is for selecting, the middle
%  from moving backwards through the images and the right for
%  moving forward.  This routine is mainly used for selecting seed
%  points for flattening.
% HISTORY: 03.14.97 ABP -- 
%	Added Axial and Coronal views. 
%	Lots of buttons and controls.
%       03.25.97 ABP -- geoLineIndices
%	11.25.97 SJC -- cuts
%	12.10.97 SJC -- new controls and new look for gui
%	12.12.97 SJC -- added capability to load of anatomy and gray matter files
%	01.07.98 SJC -- finished grouping related variables into structures
%	01.07.98 SJC -- added capability to mark voxels and save their locations
%	02.19.98 SJC -- added third window to display flattened brain
%	03.20.98 SJC, ABP -- 
%	 Smarter read/write abilities for layer1 nodes.  
%	 Trimmed read files to only those needed for code
%	 (e.g. UnfoldParams, not paramsP.m file).
%	 Forced selected start node to be in the first layer.
%	05.01.98 SJC -- changed all user inputs from the Matlab prompt to GUIs
%		        added Unfold GUI
%	07.09.98 SJC -- added ShowData display structure flag for displaying data
%			loaded from ascii files
%			added Tools -> Load and Display Data
%	07.13.98 SJC -- changed name of mrVol to mrUnfold
%
% TODO: 03.18.97 ABP--
%   *) 'unflist' button (says Brian)
%   *) colorbar for some of these???
%   *) scale the pixels to reflect actual voxel size??
%   *) devise a scheme to project flattened inplane data back
%      onto these volume anatomies to check for projection screwiness.
% BUGS:
%  HA!

curDir = cd;

% Window parameters
% 
global slimin slimax slico axisflag

activeSliceOri = 1;		% 1=sagittal slice, 2=axial, 3=coronal
axisflag=1; 			% Show axis by default

% Initializing variables
showDistance	= -1;
showGray	= -1;
showCut		= -1;
showMarks	= -1;
showData	= -1;
displayStruct.flags = [showDistance,showGray,showCut,showMarks,showData];
selectedNode.index = -1;
selectedNode.S = -1;
selectedNode.A = -1;
selectedNode.C = -1;
grayStruct.nodes = [];
grayStruct.edges = [];
layer1Struct.nodes = [];
layer1Struct.edges = [];
cutNodes = [];
mVoxelsStruct.selected = 0;
mVoxelsStruct.Area1 = [];
mVoxelsStruct.Area2 = [];
mVoxelsStruct.Area3 = [];
mVoxelsStruct.Area4 = [];
mVoxelsStruct.Area5 = [];
mVoxelsStruct.Area6 = [];
xyzc = [];
cMap = [];
displayData = [];

if exist('iNumber')  
  displayStruct.iNumber = iNumber;
else
  displayStruct.iNumber = [0 0 0];
end

if exist('radius')
  volStruct.radius = radius;
else
  volStruct.radius = 0;
end
volStruct.vData = [];
volStruct.vSize = [];
anatomy.file = [];
anatomy.dir = [];
grayMatter.hemisphere = [];
grayMatter.file = [];
if ~exist('saveDir')
  saveDir = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up the controls on the windows
% 

% Controls for window 1: display parameters, slice selection and
% orientation
%
mrWindow1Controls;

% Controls for window 2: displays slices, loading new volumes and
% gray files, setting radius and selected node, showing gray matter,
% distance, cuts, marked areas
%
mrWindow2Controls;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize the color map

% Gray scale levels for anatomy
gmap = gray(128);

% Highlight colors for overlays
% 
highlights = [ 1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1];

% Colors used to indicate the distance from a seed to other
% locations.  These range over colormap entries 135:198
dmap = hot(64);

figure(h_fig2);
colormap([ gmap; highlights; dmap] );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If there is data, put it up
%
% 07.10.98  SJC
% Maybe users should only be allowed to load stuff from the display
% window...

% Volume anatomy file specified, load it
if (exist('anatomyF') & exist('anatomyDir'))
  anatomy.dir = anatomyDir;
  set(anatomyDir_edit,'String',anatomy.dir);
  anatomy.file = anatomyF;
  set(anatomyFile_edit,'String',anatomy.file);
  [anatomy,volStruct,displayStruct,grayStruct,layer1Struct,cutNodes] = ...
     mrVolReadVolume(anatomy,volStruct,displayStruct,grayStruct,layer1Struct,cutNodes);
  for ii = 1:3
    set(iNumber_edit(ii),'String',num2str(displayStruct.iNumber(ii)));
  end
  imgStruct = mrVolShowImage(volStruct.vData,volStruct.vSize,displayStruct,h_fig2);
else
  anatomy.file = [];
  anatomy.dir = [];
end

% If no save directory is specified, assign the default one
if ~exist('saveDir')
  if ~isempty(anatomy.dir)
    defaultDirNeeded = 1;
    mrVolSetSaveDir;
  else
    saveDir = curDir;
  end
  set(saveDir_edit,'String',saveDir);
end

% If gray matter file specified, load it
if (exist('grayF') & exist('hemisphere'))
  grayMatter.hemisphere = hemisphere;
  set(grayHemisphere_edit,'String',grayMatter.hemisphere);
  grayMatter.file = grayF;
  set(grayFile_edit,'String',grayMatter.file);
  [grayMatter,grayStruct,layer1Struct] = ...
     mrVolReadGray(grayMatter,grayStruct,layer1Struct,anatomy);
else
  grayMatter.hemisphere = [];
  grayMatter.file = [];
end

% If flattened data file is specified, load it and display it
flatStruct.gLocs2d = [];
flatStruct.unfList = [];
flat.dir = [];
flat.file = [];
if (exist('flatF') & exist('flatDir'))
  h_fig3 = figure;
  mrVolControls3;
  flat.dir = flatDir;
  flat.file = flatF;
  [flatStruct,flat] = mrVolReadFlat(0,flatStruct,flat,grayMatter,anatomy);
  mrVolShowFlat(flatStruct,mVoxelsStruct,grayStruct,cutNodes,h_fig3);
end

return;






