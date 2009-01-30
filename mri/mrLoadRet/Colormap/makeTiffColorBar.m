function [colorBar, barMap] = makeTiffColorBar(mp,corLim,barSize)
% 
% 
% [colorBar barMap] = makeTiffColorBar(mp,corLim,barSize)
% 
%   load xyzabcMap.mat
%   [colorBar barMap] = makeTiffColorBar(mp);
%   imwrite(colorBar,barMap,'colorBar.tif','tiff');
% 
% or
% 
%   imshow(colorBar,barMap)
%     
% 
% AUTHOR:  Wandell
% DATE:    01.01.98
% PURPOSE:
%     Convert the mp in a fooMap.mat file into a tiff image for
%     graphing. 
% 
% ARGUMENTS:
%   
%   mp:  the color map written out in the *Map.mat file using the
%      TiffSave operation in mrLoadRet (Special->ImageManagement->TiffSave)   
%   
%   corLim: [lowest cor value, highest cor value]
%           default: [0.3,1.0]
%   
%   barSize:The size of the color bar, default: [12,128]
%   
% RETURNS:
%   
%   colorBar:  indexed image
%   barMap:    color map for the color bar
%     
% Modifications
%     

% Debugging
% fname = '/home/brian/slides/mri/Motion/AR-MTLocalize/exp2FlatCo35Map'
% cmd = sprintf('load %s',fname); eval(cmd)
% barSize = [12 128];
% corLim = [0.35 1.0]

% The first 128 values are gray levels.  The next are the
% pseudo-color overlays.  Pull out the color map values
% corresponding to the min and max correlation in the image.

mp = mp(128:256,:);

if ~exist('corLim'), corLim(1) = 0.3; corLim(2) = 1.0; end

% Set up the range of colors we will use in the display
% 
mpMin = round(1 + 127*corLim(1));
mpMax = round(127*corLim(2));

% We also choose 128 levels, but they are scaled/rounded
% over the working range
% 
mpRange = round(scale(1:128,mpMin,mpMax));

% Pull out the relevant entries of the mp for these
% correlation levels
% 
barMap = mp(mpRange,:);

% Make the image data for the map display
% 
if ~exist('barSize'),   barSize = [12, 128]; end

colorBar = [1:barSize(2)];
colorBar = colorBar(ones(barSize(1),1),:);

return;




