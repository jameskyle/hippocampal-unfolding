% mrVolTiffImage(dispImage,saveDir)
%
%AUTHOR: Poirson
%DATE:   03.18.97
%PURPOSE:
%  Take current image in mrVol, get color map, write it out as a tiff file.  
%  The user is prompted for the name
%ARGUMENTS:
%  dispImage:  Image from mrVol
%HISTORY: 03.25.98 SJC Added the save directory as an input parameter and
%	  	       added a message to the user indicating where save
%		       was done
%

function mrVolTiffImage(dispImage,saveDir)

% Assume that the correct graphics window is active.
mp = colormap;

fname = input('Enter the file name for the tiff file: ','s');

curDir = cd;
changeDir(saveDir);
tiffwrite(dispImage,mp,fname);
changeDir(curDir);

fprintf('Finished saving image in %s/%s\n',saveDir,fname);

return
