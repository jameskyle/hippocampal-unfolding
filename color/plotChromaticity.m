function [pHandle , lHandle] = plotChromaticity(wavePlot)
%
% [pHandle lHandle] = plotChromaticity(wavePlot)
%
%  plot the xy chromaticity diagram and place a dot
%  on the spectral locus at the indicated wavelengths
%
%  This routine returns a handle to the plot of xy values and
%  to the line added to close up the spectral locus.
%
%AUTHOR:
%  Wandell, 8/94
%

load xyz
wave = 360:730;

% Compute the spectral locus
xy = chromaticity(XYZ');

if nargin == 1
 waveLlist = [];
 for i = 1:length(wavePlot)
  k = find(wave == wavePlot(i));
  waveList = [waveList k];
 end
end

wRange = 30:360;		%This clears out some near zero ratios
hold off

%	Draw the main curve
if nargin == 1
 pHandle = plot(xy(1,wRange),xy(2,wRange),'-', ...
               xy(1,waveList),xy(2,waveList),'o');
 set(pHandle(2),'markersize',4,'linewidth',4)
else
 pHandle = plot(xy(1,wRange),xy(2,wRange),'-');
end
hold on

%
%  Connect the nonspectral locus line
%
lHandle = line([ xy(1,360), xy(1,30) ], [ xy(2,360), xy(2,30) ]);
hold off

%
%  Things I like
%
tick = [0:.2:.8];
set(gca,'xlim',[0 .8],'ylim',[0 .85],'xtick',tick,'ytick',tick)
axis equal, grid on


