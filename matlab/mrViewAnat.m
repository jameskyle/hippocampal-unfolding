function [imUnfoldL, imUnfoldC, cmap] = mrViewAnat(subject,paramsfile,lineNodeFile,version);
%
% mrViewAnat.m
%
% [imUnfoldL, imUnfoldC, cmap] = mrViewAnat(subject,paramsfile,[lineNodeFile],[version]);
%
% AUTHOR:	Heidi Baseler
% DATE:		3/12/97
% PURPOSE:	This function allows one to see an image of the unfolded anatomy
%		in two ways:  1) the old color scheme, where color denotes slice
%		number relative to left-most sagittal slice and 2) a new color 
%		scheme, where color denotes Euclidean distance in mm from the 
%		center of the volume from which the gray matter was extracted.
%
% ARGUMENTS:
% subjectdir:	Subject directory where unfold data live 
%		(e.g. '/orange/u1/mri/anatomy/baseler2')
% paramsfile:	Parameter file used for unfolding (in matlab subdirectory)
%
% OPTIONS:
% lineNodeFile:	Matlab .mat file containing variable "geoLineGrayNodes",
%		a list of gray matter nodes to be highlighted on
%		flattened surface. (Must be in directory containing unfolded data).
% version:	If viewing data unfolded using unfold-1.0, put a '1'.
%		Otherwise, it assumes version unfold-3.0 and no argument is needed.
%
% RETURNS:
% imUnfoldL:	A matrix containing the unfolded anatomy image coded by sagittal
%		slice number (old color scheme)
% imUnfoldC:	A matrix containing the unfolded anatomy image coded by Euclidean
%		distance in mm from volume center pixel.
% cmap:		Colormap of image.
%
% DEPENDENCIES:
%  This function requires these other functions:
%   (a) viewUnfold.m
%   (b) mrVcoord.m
%   (c) cmapPlace.m
%
% UPDATE:
% 3.31.97 - HAB - Added ability to display geodesic line drawn in volume on
% 		flattened representation.

sFactor = 1;
kernel = mkGaussKernel([5 5],[2 2]);
cmap = [gray(128); 0 0 0];
cmap2 = [cmap; 0 1 0];
ncolors = size(cmap2,1);
curdir = pwd;

% Run the paramsfile
matDir = ['/usr/local/mri/anatomy/', subject, '/matlab'];
chdir(matDir)
eval(paramsfile)

% Get to the unfolding directory and load flat information
chdir(saveDir)

% If unfold-3.0 was used:
if nargin < 4
  load flat

% Else if unfold-1.0 was used:
else
  load dist332
  load interp332
  gLocs3d = mrVcoord(xGrayVol', iSize);
end

% Find the midpoint of the volume
min3d = min(gLocs3d);
max3d = max(gLocs3d);
midpoint3d = min3d + ((max3d - min3d)/2);

% Calculate the distances between pixels in the 3 dimensions
dist3d = gLocs3d - (ones(length(gLocs3d),1)*midpoint3d);

% Convert gLocs3d distances from pixels to mm
paramsdir = ['/usr/local/mri/anatomy/', subject];
chdir(paramsdir)
load UnfoldParams
pixpermm = ones(length(gLocs3d),1)*volume_pix_size;
dist3dmm = dist3d ./ pixpermm;

% Calculate Euclidean distances from midpoint, in mm
eucdist = sqrt((dist3dmm(:,1) .^2) + (dist3dmm(:,2) .^2) +(dist3dmm(:,3) .^2));

% Make two distance images of the unfolded surface
[imUnfoldL rowL colL fSize] = viewUnfold(gLocs2d,sFactor,kernel,cmap,gLocs3d(:,3));
[imUnfoldC rowC colC fSize] = viewUnfold(gLocs2d,sFactor,kernel,cmap,eucdist);

% Get indices for nodes to be highlighted on flattened representation
if nargin > 2
  chdir(saveDir)
  eval(['load ' lineNodeFile])
  volnodes = geoLineGrayNodes;
  volidx = zeros(size(volnodes));
  for i = 1:length(volnodes)
    volidx(i) = find(unfList==volnodes(i));
  end
% Get rid of zero values
  vnnz = length(volidx) - nnz(volidx);
  strz = ['Warning:  ' num2str(vnnz) ' gray matter nodes were not found.'];
  disp(strz);
  volidx = nonzeros(volidx);
% Add highlighted gray nodes selected in volume
  for i = 1:length(volidx)
	imUnfoldL(rowL(volidx(i)),colL(volidx(i))) = ncolors;
	imUnfoldC(rowC(volidx(i)),colL(volidx(i))) = ncolors;
  end
end

% Show the two versions of the flattened image
h = figure;
clf; hold on;
image(imUnfoldL)
axis image
set(h,'Name','Old Depth Map: Distance from LEFT in slices');
cmapPlace(cmap,min(gLocs3d(:,3)),max(gLocs3d(:,3)),5)
colormap(cmap2)

h = figure;
clf; hold on;
image(imUnfoldC)
axis image
set(h,'Name','New Depth Map: Distance from CENTER in mm');
cmapPlace(cmap,min(eucdist),max(eucdist),5)
colormap(cmap2)

chdir(curdir)

cmap = cmap2;

return;

% Test values
subject = 'baseler2';
paramsfile = 'rightP4med';
lineNodeFile = 'geoLineGrayNodes';

[imUnfoldL, imUnfoldC, cmap] = mrViewAnatt(subject,paramsfile,lineNodeFile);

