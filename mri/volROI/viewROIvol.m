function viewROIvol(subject,sagList,axiList,corList);
%
% viewROIvol(subject,[sagList],[axiList],[corList]);
%
% AUTHOR:  Heidi Baseler
% DATE:    03.12.98
% PURPOSE: Function to display visual area volROIs on volume slices.
% NOTE:    ** THIS SCRIPT MUST BE RUN IN MATLAB5 **
%          Use this after you've projected visual area volROIs
%          using "flat2volROI" and then color coded them in the
%          volume using "makeROIvol".
%
% INPUTS:
% subject:       Subject's name (directory where volume data are stored).

% OPTIONAL:
% sagList:       List of sagittal slices to display (numbered left to right)
% axiList:       List of axial slices to display (numbered bottom to top)
% corList:       List of coronal slices to display (numbered front to back)
%
% HISTORY:
% 04.16.98:  HAB, Split into 2 functions.  "makeROIvol" generates
%            the volume with volROIs color-coded.
%            "viewROIvol" displays the output volume in various ways.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEBUGGING
% subject = 'baseler2';
% sagList = [33 93];
% corList = [166];
% axiList = [30];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

curDir = pwd;

close all

vDir = ['/usr/local/mri/anatomy/',subject];
chdir(vDir)
chdir('volROIs')

load ROIvol

AxiSize = volSize(3);
CorSize = volSize(2);
SagSize = volSize(1);

% Draw slices through 3d figure
%figure(1); hold off; clf;
%slice(roiVol,corList,sagList,axiList)
%shading flat
%view(110,20)
%axis image
%set(gca,'DataAspectRatio',[voxmm(3) voxmm(1) voxmm(3)]);
%colormap(cmap)

% Draw all slices as 2d images all in subplot format
% Sagittal slices:
if ~exist('sagList','var')
  sagList = [1:10:SagSize];
end
rooot = sqrt(length(sagList));
subi = round(rooot);
if rooot > subi
  subj = subi+1;
else
  subj = subi;
end

figure(2); hold off; clf
for i = 1:length(sagList)
  sagImg = (roiVol(sagList(i),:,:));
  sagImg = rot90(squeeze(sagImg));
  subplot(subi,subj,i),image(sagImg)
  colormap(cmap); axis off
  set(gca,'DataAspectRatio',[voxmm(1) voxmm(1) voxmm(3)]);
  titstr = ['title(''Sag',num2str(sagList(i)),''')'];
  eval(titstr);
end

%figure(2); orient landscape; print -dpsc sag.ps

% Coronal slices:
if ~exist('corList','var')
  corList = [1:10:CorSize];
end
rooot = sqrt(length(corList));
subi = round(rooot);
if rooot > subi
  subj = subi+1;
else
  subj = subi;
end

figure(3); hold off; clf
for i = 1:length(corList)
  corImg = (roiVol(:,corList(i),:));
  corImg = rot90(squeeze(corImg));
  subplot(subi,subj,i),image(corImg)
  colormap(cmap); axis off
  set(gca,'DataAspectRatio',[voxmm(1) voxmm(3) voxmm(1)]);
  titstr = ['title(''Cor',num2str(corList(i)),''')'];
  eval(titstr);
end

%figure(3);orient landscape; print -dpsc cor.ps

% Axial slices:
if ~exist('axiList','var')
  axiList = [1:10:axiSize];
end
rooot = sqrt(length(axiList));
subi = round(rooot);
if rooot > subi
  subj = subi+1;
else
  subj = subi;
end

figure(4); hold off; clf
for i = 1:length(axiList)
  axiImg = (roiVol(:,:,axiList(i)));
  axiImg = fliplr(rot90((squeeze(axiImg)),3));
  subplot(subi,subj,i),image(axiImg)
  set(gca,'DataAspectRatio',[voxmm(1) voxmm(3) voxmm(1)]);
  colormap(cmap); axis off
  titstr = ['title(''Axi',num2str(axiList(i)),''')'];
  eval(titstr);
end

%figure(4);orient tall; print -dpsc axi.ps

return


