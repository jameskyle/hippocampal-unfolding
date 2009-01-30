% mrTiffImage(curImage,curSize)
%
%AUTHOR: ABP, BW
%DATE:   01.14.97
%PURPOSE:
% 
%  Get the data from the currently displayed mrLoadRet image and
%  write it out as a tiff file.  The color map for the tiff file is
%  written out separately as nameMap.mat.  The user is prompted
%  for the name of the tiff file.
% 
%ARGUMENTS:
% curImage:  A vector containing the data of the current display
% curSize:   The row and col size of the curImage
%

function mrTiffImage(curImage,curSize)

[im mp] = getMrLoadRetImage(curImage,curSize);

%  Write out the tiff file as fname.tif
%  
fname = ...
    input('File name for the Tiff and Map file (no extension): ','s'); 
tiffName = sprintf('%s.tif',fname);
tiffwrite(im,mp,tiffName);

%  Write out the color map as fnameMap.mat
%  
mapName = sprintf('%sMap',fname);
cmd = sprintf('save %s mp',mapName);
eval(cmd);

return;
