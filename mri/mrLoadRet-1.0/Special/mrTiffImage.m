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
fname = input('Basename for tiff (and Map) file: ','s'); 
%  
tiffName = sprintf('%s.tif',fname);
mapName = sprintf('%sMap.mat',fname);
fprintf('Writing files: %s and %s\n',tiffName,mapName);

tiffwrite(im,mp,tiffName);

%  Write out the color map as fnameMap.mat
%  We don't really need the map as a separate file because the
%  color map is contained in the tif file, too.
% 
cmd = sprintf('save %s mp',mapName);
eval(cmd);

return;
