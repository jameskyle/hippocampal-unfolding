function [graphWin,sHandle] = ...
    mrSurfROIRet(curAnat,tSeries,selpts,sd,viewParms,nSample,graphWin,loadRetWin)
%
% [graphWin,sHandle] = ...
%    mrSurfROIRet(curSer,tSeries,selpts,sd,viewParms,nSample,graphWin,loadRetWin)
%
%AUTHOR:  Engel
%DATE:    The distant past
%
%	Produces a surface indicating the strength of the signal
% at each point in time. Each step in X is an increment of time,
% Each step in Y is a new point in the ROI, and Z corresponds to 
% signal intensity.
%
%ARGUMENTS:
%  curAnat:  Which anatomical to use
%  tSeries:  Time series
%  selpts:   Selected points in roi
%  
%OPTIONAL ARGUMENTS:
%  sd:     Temporal and spatial sd for blurring kernel (DEFAULT [5 4])
%  viewParms: Azimuth and elevation for the map (DEFAULT = -97.5, 45)
%  nSample:   The sample spacing when plotting (DEFAULT = 1)
%  graphWin:
%  loadRetWin:
%
%RETURNS:
%  sHandle:  Handle to the surface plot

% 6/10/03 MMZ	Fixed isempty bug
% 1/23/97 gmb   Plots in a second window

if isempty(sd)
 tSd = 5;  sSd = 4;
else
  sd
  tSd = sd(1); sSd = sd(2);
end

locSelpts = mrExtractROIRet(curAnat,selpts);
if ~any(locSelpts)
   return;
else
   locSelpts = locSelpts(1,:);
end

if isempty(nSample)
  nSample = 1;
end

if isempty(graphWin)
% MMZ if graphWin ~= []
  if ~isempty(graphWin)
    figure(graphWin);
  else
    graphWin=figure(999);
  end
  set(gcf,'Name','Time Series');
end

mrColorBar(0,'off');

roi = tSeries(:,locSelpts);
roi = mrDeTrend(roi);
kernel = mkGaussKernel([9 9],[tSd sSd]);
roi = convolvecirc(roi,kernel);
if nargin >= 6
  sRoi = size(roi);
  roi = roi([1:nSample:sRoi(1)],:);
end

sHandle = surf(roi);
axis 'ij'

% Should check viewParams and handle it properly.  In the
% meantime, we are just using the defaults.
% 
view([-97.5 45]);

if exist('loadRetWin')
  figure(loadRetWin);
end
