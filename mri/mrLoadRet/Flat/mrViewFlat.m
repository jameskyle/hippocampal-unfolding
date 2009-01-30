function mrViewFlat(subjectdir,hemisphere,datadir,expnum,cothresh)

% mrViewFlat(subjectdir,hemisphere,datadir,expnum,cothresh)
%
% AUTHOR: 		Steve Engel, Brian Wandell?
% MODIFIED BY: 		Geoff Boynton, Jon Demb, Heidi Baseler
% RECENT UPDATE: 	2.27.97
% PURPOSE: 		View functional data on flattened cortex
% PREVIOUS LIVES: 	snipMark.m, showFlatData.m
%
% INPUTS:
%
% subjectdir:	Subject directory containing unfolded anatomy.
%		e.g. 'woodfill'
% hemisphere:	'right' or 'left'
% datadir:	Directory containing functional data (whole pathname).
%		e.g. '/kusr1/mri/jw/100496'
% expnum:	Experiment (scan) within session to be viewed.
% cothresh:	Correlation threshold.
%
% NOTE!:  To use this function, you must have the following directories 
%	in your matlab startup.m file, in this order:
% 	/usr/local/matlab/toolbox/stanford/mri/unfold-1.0/old
% 	/usr/local/matlab/toolbox/stanford/mri/unfold-1.0
% 	/usr/local/matlab/toolbox/stanford/mri/unfold

% Set up for functional viewing
% First, set up dimensions of spatial filter
% Envelope width of Gaussian window (determines size of the squares)
sup = [11 11];
% Standard deviation of Gaussian filter
sd = [2 2];
kernel = mkGaussKernel(sup,sd);
sFactor = 2;
noFuncVal = NaN; noGrayVal = -999;

% Set up colormap
mp = [hsv(128)];
mp2 = linearCmap(mp,1.8);
cmap = cmapRotate(mp2,14);
cmap = [cmap; 0 0 0];

homedir = pwd;
flatdir= '/usr/local/mri/anatomy/';
unfdir=[flatdir,subjectdir,'/',hemisphere,'/unfold'];
chdir(unfdir)

load flat
locs2d = gLocs2d;
locs3d = gLocs3d;
badpts = isnan(locs2d(:,1));
locs2d = locs2d(~badpts,:);
locs3d = locs3d(~badpts,:);

chdir(datadir)
load CorAnal
load ExpParams
load anat
load bestrotvol

% Calculate the 3d functionals locations from the anatomical location
flocs3d = mrVol2Func(locs3d,rot,trans,scaleFac);
clear flatComplex

% Make functional volumes
volco = makeExpVolume(co,numofanats,expnum);
volph = makeExpVolume(ph,numofanats,expnum);
global interpflag;
interpflag = 1;

% Map onto anatomies
graySin = mrExtractImgVol(sin(volph),curSize,numofanats, ...
	                       flocs3d,[1,numofanats],noFuncVal);
grayCos = mrExtractImgVol(cos(volph),curSize,numofanats, ...
                       flocs3d,[1,numofanats],noFuncVal);

% Flatten functional data
flatPh = gridImage(sFactor,locs2d,atan2(graySin,grayCos),noGrayVal);
flatCo = flattenFunc(volco,curSize,numofanats,locs2d,flocs3d, ...
	 sFactor,noFuncVal,noGrayVal);

% Smooth and convert to color-map values
% This generates a sparse map.
imPh = makePhaseIm(flatPh,flatCo,cothresh,noFuncVal,noGrayVal,kernel,size(cmap,1));

figure(1)
clf, hold off
image(imPh);
colormap(cmap)
axis image, axis off
corstr = num2str(cothresh);
title([subjectdir,', ',hemisphere, ' hemisphere, correlation threshold: ',corstr]);
cmapPlace(cmap,0,360,8);

chdir(homedir)

return

