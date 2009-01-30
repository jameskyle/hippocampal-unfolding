function [roiVol,volSize,voxmm,volROIlist,cmap] = makeROIvol(subject,saveStr,extraROI);
%
% [roiVol,volSize,voxmm,volROIlist,cmap] = makeROIvol(subject,saveStr,extraROI);
%
% AUTHOR:      Heidi Baseler
% DATE:        03.12.98
% PURPOSE:     Function to color-code visual area ROIs in 3d volume
%              and save it.
% ASSUMPTIONS:
%
%           1) ROIs in the volume must be stored in directory
%              /usr/local/mri/anatomy/[subject]/volROIs.
%              You can create them by selecting FROIs in the
%              flattened representations, and then projecting
%              them to the subject's volume using "flat2volROI".     
%
%           2) volROI names for early visual areas must be:
%              V11L, V2VL, V2DL, V3VL, V3DL, V3AL, V4VL
%              V11R, V2VR, V2DR, V3VR, V3DR, V3AR, V4VR.
%              (e.g. 'V11L.mat').
% 
% INPUTS:
% subject:     Name of directory (usually subject's last name) containing 
%	         volume data (e.g. 'wandell', or 'ruddock/gy')
% saveStr:     Do you want to save the output volume, color-coded
%                with volROIs in the current directory?  ('y' or 'n')
%
% OPTIONS:
% extraROI:    Name of extra volROI you'd like to plot along with
%                the standard early visual areas
% 
% RETURNS:
% roiVol:      The volume with all voxels color-coded for the
%                different visual areas.
% volSize:     Dimensions of the 3-d output volume.
% voxmm:       Size of each voxel in mm.
% volROIlist:  List of visual areas and other volume ROIs that were
%              color-coded.
% cmap:        Colormap for the color-coded volume
% 
% ROIvol.mat:  Workspace that gets saved out containing all of
%              returned variables if saveStr == 'y'.
%
% NOTE:        Use 'viewROIvol.m' for viewing slices through the
%              color-coded volume.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEBUGGING
%clear all
%subject = 'tyler';
%subject = 'baseler2';
%saveStr = 'n';
%extraROI = 'symm022698b3';
%extraROI = 'symmexp2';
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
curDir = pwd;

% Load the 3d volume
vDir = ['/usr/local/mri/anatomy/',subject];
chdir(vDir)
if ~exist('vData')
  [vData vSize] = readVolume('vAnatomy.dat');
end

% Scale the gray volumes in the volume between 1 and 128
vData = scale(vData,1,128);

% Scale pixel dimensions appropriately
load UnfoldParams
voxmm = 1 ./volume_pix_size;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INSERT volROIs into volume
% First, for each visual area, load and combine ROIs
chdir('volROIs');

% Load in visual areas and reorder them to register with volume
% axial, coronal, sagittal
load V11R
v1r = [volROI(2,:); volROI(1,:); volROI(3,:)];
load V11L
v1l = [volROI(2,:); volROI(1,:); volROI(3,:)];
V1 = [v1l v1r];

load V2DR
v2dr = [volROI(2,:); volROI(1,:); volROI(3,:)];
load V2DL
v2dl = [volROI(2,:); volROI(1,:); volROI(3,:)];
load V2VR
v2vr = [volROI(2,:); volROI(1,:); volROI(3,:)];
load V2VL
v2vl = [volROI(2,:); volROI(1,:); volROI(3,:)];
V2 = [v2vl v2dl v2vr v2dr];

load V3DR
v3dr = [volROI(2,:); volROI(1,:); volROI(3,:)];
load V3DL
v3dl = [volROI(2,:); volROI(1,:); volROI(3,:)];
load V3VR
v3vr = [volROI(2,:); volROI(1,:); volROI(3,:)];
load V3VL
v3vl = [volROI(2,:); volROI(1,:); volROI(3,:)];
V3 = [v3vl v3dl v3vr v3dr];

load V3AR
v3ar = [volROI(2,:); volROI(1,:); volROI(3,:)];
load V3AL
v3al = [volROI(2,:); volROI(1,:); volROI(3,:)];
V3A = [v3al v3ar];

load V4VR
v4vr = [volROI(2,:); volROI(1,:); volROI(3,:)];
load V4VL
v4vl = [volROI(2,:); volROI(1,:); volROI(3,:)];
V4V = [v4vl v4vr];

load MTLRip
MT = [volROI(2,:); volROI(1,:); volROI(3,:)];

% Add extra ROI (custom made), if requested.
if nargin > 2
  eval(['load ',extraROI]);
  EXT = [volROI(2,:); volROI(1,:); volROI(3,:)];
% List of visual areas to be highlighted
  volROIlist = strvcat('V1','V2','V3','V3A','V4V','MT','EXT');
else
  volROIlist = strvcat('V1','V2','V3','V3A','V4V','MT');
end

clear v1l v1r v2vl v2vr v2dl v2dr v3vl v3vr v3dl v3dr v3al v3ar v4vl v4vr volROI

% Insert (color-code) pixels for each visual area in above list
k=1;
for k = 1:size(volROIlist,1);
  visarea = volROIlist(k,:);
  minslice = eval(['min(',visarea,'(3,:))']);
  if minslice < 1
    minslice = 1;
  end
  maxslice = eval(['max(',visarea,'(3,:))']);
  if maxslice > vSize(3)
    maxslice = vSize(3);
  end
  for i = minslice:maxslice
    eval(['roiIndices = find(',visarea,'(3,:) == i);']);
    eval(['anatIndices1 = ',visarea,'(1,roiIndices);']);
    goodindices = [];
    goodindices = anatIndices1 <= vSize(1);
    anatIndices1 = anatIndices1(goodindices);
    eval(['anatIndices2 = ',visarea,'(2,roiIndices);']);
    goodindices = [];
    goodindices = anatIndices2 <= vSize(2);
    anatIndices2 = anatIndices2(goodindices);
    img = reshape(vData(i,:),vSize(1:2));
    for j = 1:min([length(anatIndices1) length(anatIndices2)])
      img(anatIndices1(j),anatIndices2(j))=128+k;
    end
    vData(i,:) = [img(:)'];
  end
end

clear volROI img i j k roiIndices
clear anatIndices1 anatIndices2 goodindices ans vDir visarea
clear V1 V2 V3 V3A V4V MT EXT volume_pix_size

% Reshape the "volume" into a real 3d volume
[vData3] = reshape(vData,vSize(3),vSize(1),vSize(2));

% Orient volume properly for viewing (it comes up like pColor)
V = permute(vData3,[1 3 2]);
roiVol = flipdim(V,3);
clear V vData3
volSize = size(roiVol)

% Make appropriate colormap; the factor of 5/8 lightens gray map
gmap = gray(round(128*5/8));
cmap = [gmap; ones(128-round(128*5/8),3); 1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1; 1 .5 0];

if saveStr == 'y'
  save ROIvol roiVol volSize cmap volROIlist voxmm;
  disp('Saving volume in volROIs directory in file called ROIvol.mat');
end

chdir(curDir);

return

