function CondPlot(fMRI, frameRate, condList, options)

% function CondPlot(fMRI, frameRate, condList, options);
% 
% Plot one or more time series that correspond to the condition
% fields of the input structure. Ploting symbols are
% automatically varied from condition-to-condition using
% alternately unfilled and filled plot symbols. Errorbars and
% annotation can optionally be added.
%
% INPUTS
% ---------------------------------------------------------------
% fMRI: a structure where each field is the name of a condition.
% Each condition field must, in turn, contain ROI subfields. Each
% ROI field must, in turn, contain two subfields: avgTSeries and
% stdErrors, containing a time series and the corresponding
% errors. Example:
% fMRI = 
%
%              hits: [1x1 struct]
%            misses: [1x1 struct]
%       falseAlarms: [1x1 struct]
%    correctRejects: [1x1 struct]
%
% fMRI.hits =
%
%    V1: [1x1 struct]
%    MT: [1x1 struct]
%
% fMRI.hits.V1 = 
%
%    avgTSeries: [  1x15 double]
%     stdErrors: [  1x15 double]
%
% frameRate: the time period between each point the time
% series. 
% condList: [optional] list of condition fields to plot.
% options: [optional] cell array of strings designating the
% following (case insensitive) options --
% 'Text'       Print condition name at end of time series
% 'Errors'   Display all error bars
% 'fewErrors'  Display only the two central error bars


if ~exist('frameRate'); frameRate = 1; end
if ~exist('options'); options = 'none'; end

% Figure out conditions:
condNames = fieldnames(fMRI);
if ~exist('condList'); condList = 1:length(condNames); end
nConds = length(condList);

% Set up the figures and scaling
ROIList = {};
fh = figure;
mxv = [];
mnv = [];
mxt = [];
nPlots = 0;
for iC=1:nConds
  iCond = condList(iC);
  condName = condNames{iCond};
  eval(['condS = fMRI.', condName, ';']);
  ROINames = fieldnames(condS);
  nROIs = length(ROINames);
  for iROI=1:nROIs
    ROIName = ROINames{iROI};
    eval(['avgTSeries = condS.', ROIName, '.avgTSeries;']);
    mxt = [mxt, (length(avgTSeries)-1)*frameRate];
    mnv = [mnv, min(avgTSeries(:))];
    mxv = [mxv, max(avgTSeries(:))];
    % Make a new figure for each newly appearing ROI:
    [new, jROI, ROIList] = NewROIPlot(ROIName, ROIList);
    figure(fh + jROI - 1);
    if new
      nPlots = nPlots + 1;
      hold on;
      xlabel('Time (s)') 
      ylabel('FMRI response (%)')
      title(['Pattern-Detection Task for ROI: ', ROIName]);
    end
  end
end
if length(strmatch('text', lower(options)))
  mxt = 1.25 * mxt;
end
axisV = [0, max(mxt(:)), 1.1*min(mnv(:)), 1.1*max(mxv(:))];
for iP=0:nPlots-1
  figure(iP + fh);
  axis(axisV);
end

% Plot the data points and lines
plotSym = {'o', 's', '#', 't', 'd'};
fillSym = {'', 'f'};
nSyms = length(plotSym);
for iC=1:nConds
  iSym = round(iC/2);
  iFill = mod(iC, 2) + 1;
  plotSpec = ['k', plotSym{iSym}, fillSym{iFill}, '-'];
  iCond = condList(iC);
  condName = condNames{iCond};
  eval(['condS = fMRI.', condName, ';']);
  ROINames = fieldnames(condS);
  nROIs = length(ROINames);
  for iROI=1:nROIs
    % Loop over all ROIs
    ROIName = ROINames{iROI};
    [new, jROI, ROIList] = NewROIPlot(ROIName, ROIList);
    figure(fh + jROI - 1);
    % Extract the average time series and errors; plot them:
    eval(['avgTSeries = condS.', ROIName, '.avgTSeries;']);
    t = 0:frameRate:(length(avgTSeries)-1)*frameRate;
    nPts = length(t);
    if iCond > nSyms*2
      plotSym = {plotSym{:}, plotSym{:}};
      nSyms = nSyms * 2;
    end
    myplot(t, avgTSeries, plotSpec);
    if length(strmatch('text', lower(options)))
      text(t(nPts)+0.2*frameRate, avgTSeries(nPts), condName);
    end
    if length(strmatch('err', lower(options))) | length(strmatch('few', lower(options)))
      eval(['stdErrors = condS.', ROINames{iROI}, '.stdErrors;']);
      if length(strmatch('few', lower(options)))
	iErr = round(length(t)/2);
	t = t(iErr-1:iErr);
	stdErrors = stdErrors(iErr-1:iErr);
	avgTSeries = avgTSeries(iErr-1:iErr);
      end
      myerrorbar(t, avgTSeries, stdErrors, 'k');
    end
  end
end

