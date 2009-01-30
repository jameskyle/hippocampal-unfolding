function [gray2inplane,gray2flat] = ...
    mrCreateGray2Image(brainSide,gLocs3d,rowF,colF,fSize);
% 
%AUTHOR: Boynton, Wandell
%PURPOSE:
%  Create a pair of vectors that store the gray matter positions
% in the flattened representation (gray2flat)
% and gray matter positions in the inplane representation
% (gray2inplane). 
% 
%  The length of each vector is equal to the number of gray
%  matter points. 
%  The entries of these are
%  
%   gray2inplane:  An index that specifies the location of each
%  gray matter point in the inplanes.
%   gray2flat:     An index that specifies the location of each
%  gray matter point in the flat representation.
%  
% By using mrVcoord, these indices can be converted to the
%  coordinates of the points in the flat or inplane
%  representations. 
%
% Suppose we have flat = (col,row) values in the flat representation,
% then we would do the following sequence
%
%  xFlat = mrVcoord(flatCoords,[fSize 1s])
%  xInplane = [];
%  for i=1:length(xFlat)
%   tmp = find(gray2flat(xFlat(i)))
%   xInplane = [gray2inplane(tmp), xInplane];
%  end
%  inplaneCoords = mrVcoord(xInplane,curSize);
%
% And in the inverse direction,
%
%  xInplanes = mrVcoord(inplaneCoords,curSize)
%  xFlat = [];
%  for i=1:length(xInplanes)
%   tmp = find(gray2Inplane(xInplanes(i)))
%   xFlat = [gray2flat(tmp), xFlat];
%  end
%  flatCoords = mrVcoord(xFlat,[fSize 1s]);
%

% 
% Produced by mrAlign.  Contains rot,trans and scaleFac
% 

load bestrotvol

% Loads in curSize for the inplane image sizes
% 
load anat

% Converts the gray matter locations into the functional
% coordinate frame, so that gLocsFunc are gray matter coords in the
% functional volume.
%

gLocsFunc = mrGray2Func(gLocs3d,rot,trans,scaleFac);
 
% Find indices of these coordinates
gray2inplane = mrVcoord(gLocsFunc,curSize);

% Convert these row and column positions to index values
%
gray2flat = mrVcoord([colF rowF ones(length(colF),1)],fSize);   

