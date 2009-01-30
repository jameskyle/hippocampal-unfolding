function mrVolFROI3d(subject,hemisphere,ROIfile,anatomyF,iNumber];
%
% AUTHOR:  Heidi Baseler
% DATE:    3.31.97
% PURPOSE: Function to display ROIs chosen from flattened data on volume slices.
% NOTE:    ** THIS SCRIPT MUST BE RUN IN MATLAB5 **
%          Assumes the script is run from the directory containing both 
%          the FROI and the flattened anatomy files 
%          ('Fanat_left.mat' and 'Fanat_right.mat').
%
% INPUTS:
% subject:	Name of directory (usually subject's last name) containing 
		volume data (e.g. 'wandell', or 'ruddock/gy')
% hemisphere:  	'left' or 'right'
% ROIfile:	Name of ROI file (without the 'FROI' suffix) (e.g. 'hbRV1')
% anatomyF:	Name of volume anatomy file (usually 'vAnatomy.dat')
% iNumber: 	3-item row vector containing 3 cardinal slices to be viewed
%		(e.g. [86 109 130]).

% Debugging parameters
%  The test data I've been using are in (go to directory):
% /khaki/u2/mri/gyretino/043096b
%
%ROIfile = 'gyRV1';
%subject = 'ruddock/gy_120196';
%hemisphere = 'right';
%anatomyF = 'vAnatomy.dat';
%iNumber = [86 100 161];

curDir = pwd;

% Load the ROI from the current (data) directory
roicom = ['load ', ROIfile, 'FROI'];
eval(roicom);
clear roicom
eval(['load Fanat_', hemisphere]);
eval(['xselpts = selpts_', hemisphere, '(1,:);']);

% Load gLocs3d, so we can get the 3d coordinates for the ROI in the volume
flatdir = ['/usr/local/mri/anatomy/', subject, '/', hemisphere, '/unfold/leftmedlat'];
chdir(flatdir)
load flat
[vRoiCAS] = gLocs3d(xselpts,:);
% Change 3d ordering to match that of ROI and gLocs3d
[vRoiSAC] = [vRoiCAS(:,3) vRoiCAS(:,2) vRoiCAS(:,1)];

% Load the volume into a real 3d volume!
vDir = ['/usr/local/mri/anatomy/', subject];
chdir(vDir)
[vData vSize] = readVolume(anatomyF);
[vData3] = reshape(vData,vSize(3),vSize(1),vSize(2));
clear vData
imin = min(min(min(vData3)));
imax = max(max(max(vData3)));

% Insert ROI pixels into image
for i = 1:length(vRoiSAC)
   vData3(vRoiSAC(i,1),vRoiSAC(i,2),vRoiSAC(i,3)) = imax+1;
end

% Orient volume properly for viewing (it comes up like pColor)
V = permute(vData3,[1 3 2]);
Vf = flipdim(V,3);
clear V vData3

% Create a colormap
% gray(100) works, even though the image values exceed 100
cmap = ones(imax+1,3);
cmap(1:100,:) = gray(100);
% Set ROI points to red
cmap(imax+1,:) = [1 0 0];

% Scale pixel dimensions appropriately
load UnfoldParams
voxmm = 1 ./volume_pix_size;
sagmm = voxmm(3);
aximm = voxmm(2);
cormm = voxmm(1);

chdir(curDir);

% Draw figure
close all
figure;
%slice(Vf,70,63,51)
slice(Vf,iNumber(3),iNumber(1),vSize(1)-iNumber(2))
shading flat
view(30,30)
axis image
%set(gca,'DataAspectRatio',)  
colormap(cmap)
colorbar

return;

