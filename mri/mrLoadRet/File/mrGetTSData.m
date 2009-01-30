function tsData = mrGetTSData(curAnat,tSeries,selpts,skipImages)
%
%    tsData = mrGetTSData(curAnat,tSeries,selpts,skipImages)
%
%AUTHOR:  Wandell
%DATE:    08.15.95
%PURPOSE: 
%
%  Return the raw time series data from the currently selected region.
%  The time series from the selected pixels are returned in the columns
%  of the mrLoadRet variable called tsData.
%
%ARGUMENTS:
%  curAnat:  The current anatomical slice
%  tSeries:  The raw time series data
%  selpts:   The currently selected points.  The format of selpts is:
%            selpts(1,:) = location in the image as a single number
%            selpts(2,:) = which anatomical image
%  skipImages:  The number of images to skip at start of experiment.
% 

% First, use this routine to determine the ones associated
% with the current anatomy.
%
selpts = mrExtractROIRet(curAnat,selpts);
if ~any(selpts)
 disp('No points are selected.')
 return;
else
 selpts = selpts(1,:);
end

if ~any(tSeries)
 disp('Please load tSeries')
 return;
end

tsData = tSeries(skipImages+1:size(tSeries,1),selpts);
