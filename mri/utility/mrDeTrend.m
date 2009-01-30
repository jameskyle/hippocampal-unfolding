function newSeries = mrDeTrend(oldSeries)
%
% newSeries = mrDeTrend(oldSeries)
%
%AUTHOR:  Wandell
%DATE:  1993-94
%PURPOSE:
%
%  mrDeTrend fits an affine function to a data set and returns
%  a new series with the best-fitting affine term term removed.
%  The routine works by fitting an affine function to the data
%  set and then subtracting the best fit affine.
%
%  oldSeries:  The columns should contain the time series data
%
%CHANGED:  12.04.95 Engel
%	   05.31.96 -- Check that time-series is in the columns.
%		       Added a few comments -- BW

if nargin ~= 1 
 error('mrDeTrend:  Should be called with 1 argument')
end

oSize = size(oldSeries);
if oSize(1) == 1
 disp('Time series data should be in a column vector')
 oldSeries = oldSeries';
 oSize = size(oldSeries);
end

model = [ 1:oSize(1); ones(1,oSize(1)) ]';
wgts = model\oldSeries;
fit = model*wgts;
newSeries = oldSeries - fit;

% Older code for purely 1d case
%
% oLength = length(oldSeries);
% model = [(1:oLength); ones(1,oLength)]';
% wgts = model\oldSeries';
% fit = model*wgts;
% newSeries = oldSeries - fit';


