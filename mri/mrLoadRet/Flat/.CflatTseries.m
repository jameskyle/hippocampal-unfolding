function tSeriesF = flatTseries(gray2flat,gray2inplane,numofanats,curSize,fSize,tFrames,exp,nExp)
% function [tSeriesF, fSize] =  ...
%    flatTseries(gray2flat,gray2inplane, ...
%    numofanats,curSize,fSize,tFrames,exp,nExp)
%
% AUTHOR:  Boynton, Wandell
% DATE:    08.08.96
%
% HISTORY:
%  12/12/96  gmb  Fixed bug regarding looping through inplanes
%
%  NOTE:  Actually, I believe that this bug was fixed around 07/15/97
%  by gmb.  The old code is saved in the file BADflatTseries.m.
%  The problem was that it was loading each tSeries file in an
%  outer loop, then looping through each inplane in an inner loop
%  (even though each tSeries file is specific for a single
%  inplane).  The results was that it effectively averaged the
%  value at each pixel across all inplanes.  The bad version
%  crept into mrLoadRet-0.0 (Li Lea's matlab5 update) and 
%  then mrLoadRet-1.0.- hab
%
%  01/22/98  hab  Updated for matlab5 (changed ~=[] to ~isempty)
%  Added some comments. 
%  Copied the right version to mrLoadRet-0.0 and mrLoadRet-1.0
%
% PURPOSE:
% To create flattened versions of the timeseries files.  The
% appropriate pixels are taken from each inplane and saved out 
% into new FtSeries files, one for each experiment and each hemisphere.
%
% INPUTS:
% gray2flat and gray2inplane are vectors that code the positions
% of the gray matter in the flattened and inplane
% representations.  See mrCreateGray2Image.m
% 
% numofanats:  number of anatomy image for inplanes
% tFrames:     number of temporal samples
% exp:  which experiment in that night's series
% nExp: number of experiments that night
% curSize:  image size of the inplanes
% 
% RETURNS
% tSeriesF:  The flattened timeseries.

% Figure out gray matter locations in 3d in the functional volume
% gLocsFunc is a nGray x 3 array.  The data points are rounded to
% fall on functional voxels.
%
gLocsFunc = mrVcoord(gray2inplane,curSize);

% This is the number of voxels in the functional volume
%
volumeLength = prod(curSize)*numofanats;

% These are the row and col locations of the gray-matter in the
% flattened representation
% 
tmp = mrVcoord(gray2flat,fSize);
colF = tmp(:,1); rowF = tmp(:,2);

nFrames = length(tFrames);

% Allocate or re-initialize tSeriesF and its counter
% 
tSeriesF = zeros(nFrames,prod(fSize));
tSeriesC = zeros(1,size(tSeriesF,2));

% Figure out the tSeries for this exp
% 
tSeriesList = exp + [0:(numofanats-1)]*nExp;

% Initialize for the anatomies
% 
thisAnat = 1;

% Here's where GMB fixed the bug around 7/97.  He moved the 
% loop cycling through the anatomies to the outside, and got
% rid of the additional (unnecessary) outside loop which cycled 
% through the tSeries.  - hab
%
for thisAnat = 1:numofanats
  t=tSeriesList(thisAnat);
  eval(['load tSeries',num2str(t)]);
  s = sprintf('Loading tSeries %d',t);
  disp(s)
  % Find the index into the functional volume for 
  % the current plane
  xLocsFp = find(gLocsFunc(:,3) == thisAnat);  
  %  size(xLocsFp), max(xLocsFp)
%  if xLocsFp ~= []
  if ~isempty(xLocsFp)  % hab (matlab5 update)
    % Make the index into this plane, so we can address the proper
    % columns of tSeries
    % plot(rowF(xLocsFp),colF(xLocsFp),'x')
    xFlatImage= ...
	mrVcoord([colF(xLocsFp) rowF(xLocsFp) ...
	    ones(length(xLocsFp),1)],fSize);   
    
    % Make the index into the original tSeries data.  The variable
    % curSize is the (row,col) size of the implicit tSeries image.   
    % mrShowImage(tSeries(1,:),curSize)
    % gLocsFunc is structured as (x,y,z), which is (col,row,nplane).
    % 
    xTseries =  ...
	mrVcoord([gLocsFunc(xLocsFp,[1 2]) ...
	    ones(length(xLocsFp),1)],curSize); 
    
    %There will be duplicates: some of the gray matter maps to the
    %same voxel. So, we need to sort and merge these values
    tSeriesF(:,xFlatImage) = ...
	tSeriesF(:,xFlatImage) + tSeries(tFrames,xTseries);
    
    % Mark each grid point in the flattened image where we added a
    % a tSeries
    tSeriesC(xFlatImage) = tSeriesC(xFlatImage) + 1;
  end 
end 					%for thisAnat...
%mrShowImage(tSeriesC,fSize,'s',hsv(3));
list = find(tSeriesC > 1);
for i= 1:nFrames
  tSeriesF(i,list) = tSeriesF(i,list) ./ tSeriesC(list);
end
%mrShowImage(tSeriesF(1,:),fSize,'s');


return 					% end of routine




