function [xyzc, cMap] = mrLoadDispData(fileDirName)
% function [xyzc, cMap] = mrLoadDispData(fileDirName)
%
% 07.09.98  SJC
%
% PURPOSE:	Load in an ascii data file of the format:
%
%			number of colors
%			Red1 Green1 Blue1
% 			. . .
%			RedN GreenN BlueN
%			x y z index for point 1
% 			x y z index for point 2
% 			...
%			x y z index for point M
%
%		where
%		N is the number of different colors used
%		M is the total number of data points
%
% ARGUMENTS:	fileDirName is the directory and name of the data file
%		to be loaded
% RETURNS:	cMap:	the Red, Green, Blue colormap for the data to
%			be displayed
%		xyzc:	the x, y, z locations of the data points and
%			the index of each data point into the colormap
%

% Check validity of file name
%
if ~exist(fileDirName,'file')
  errstring = sprintf('%s not found.\nData file not loaded.',fileDirName);
  errordlg(errstring);
  cMap = [];
  xyzc = [];
  
else
  fid = fopen(fileDirName,'r');
  
  nColors = fscanf(fid,'%d',1);
  
  cMap = fscanf(fid,'%f',[3 nColors])';
  
  xyzc = fscanf(fid,'%d',[4 inf])';
  
  fclose(fid);

  % Check validity of data.  The maximum index into the colormap cannot
  % exceed the number of rows in the colormap in a valid data set.
  %
  if (max(xyzc(:,4)) > nColors)
    errstring = sprintf('%s contains invalid data.\nData file not loaded.',fileDirName);
    errordlg(errstring);
    cMap = [];
    xyzc = [];
    
  else
    % Add 1 to x,y,z locations (Matlab format)
    xyzc(:,1:3) = xyzc(:,1:3) + 1;
  
    % Tell the user load was successful
    msg = sprintf('Data in %s loaded.\n',fileDirName);
    msgbox(msg);
  end
end

return;