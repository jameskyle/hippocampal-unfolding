function [maxLMS,meanRGB]=maxConeContrast(meanLMS,deltaLMS,displayP,cones);
%
% function [maxLMS,meanRGB]=maxConeContrast(meanLMS,deltaLMS,displayP,cones)
%
% AUTHOR: Wandell, Baseler
% DATE:   11.1.96
% PURPOSE:
%
% Given a set of display primaries, determine the maximum
% contrast that can be obtained in a particular color direction.
% This routine (and all others) takes stimulus specifications in
% LMS coordinates.
%
% ARGUMENTS
%
% meanLMS:  Mean display level
% deltaLMS: Matrix whose columns specify the relative L,M,S
%           weights of the stimulus perturbation. The LMS contrast
%           is deltaLMS ./ meanLMS.
% displayP: Matrix whose columns are the display SPD at maximum
%           intensity  (default SanyoLCD)
% cones:    Matrix whose columns are the cone absorptions
%           (default Smith-Pokorny)
%
% RETURNS
% maxLMS:  Maximum contrast given deltaLMS, meanLMS, and displayP
% meanRGB:  Linear intensities in RGB space for meanLMS
%
% UPDATE:   08.26.97  HB - Modified to take a matrix of color
%           directions, rather than just one.

% Debugging values
%deltaLMS = [1 0 0; 1 .5 0; 1 1 0; .5 1 0; 0 1 0; -.5 1 0; -1 1 0; -1 .5 0]';
%meanRGB = [.5 .5 0];

% Set up input defaults
%
% Smith Pokorny as default cones
%
if nargin < 4
  load ncones
  cones = spCones;
end

% SanyoLCD is the default display
%
if nargin < 2
  load sanyoLCD
  displayP = sanyoLCD;
end

% Calculate the conversion
% 
rgb2lms = cones'*displayP;
maxLMS = rgb2lms*ones(3,1);

% Check that meanLMS is in range
%
err = checkRange(meanLMS,[0 0 0]',maxLMS);
if err ~= 0
  error('meanLMS out of range')
end

% Compute the mean (linear) RGB values
%
lms2rgb = inv(rgb2lms);
meanRGB = lms2rgb*meanLMS;

% Check whether rgb values are within the unit cube
%
err = checkRange(meanRGB,[0 0 0]',[1 1 1]');
if err ~= 0
  error('meanRGB out of range')
end

% Initialize output matrix "maxLMS"
maxLMS = zeros(1,size(deltaLMS,2));

for i = 1:size(deltaLMS,2)
  deltaRGB = lms2rgb*deltaLMS(:,i);

% Find the values that bottom out the RGB values on the 0 side.
% Then choose the smallest maxLMS as a candidate.
%
% zmaxLMS.*(+/- deltaRGB) + meanRGB = 0

  tmpFactor = -(meanRGB) ./ deltaRGB;
  zmaxLMS = min(abs(tmpFactor));

% Now find the maxLMSs that get us to 1 in the RGB cube,
% and find the smallest of these:
% umaxLMS.*(+/- deltaRGB) + meanRGB = 1
  tmp2Factor = (ones(3,1) - meanRGB) ./ deltaRGB;
  umaxLMS = min(abs(tmp2Factor));

  maxLMS(1,i) = min(zmaxLMS,umaxLMS);
end

return

% To check that the value we chose yields an rgb
% value that is on the edge of the unit cube somewhere,
% but otherwise within the unit cube, do this
%
% in = lms2rgb*(maxLMS*deltaLMS + meanLMS)
% 
% checkRange(lms2rgb*(maxLMS*deltaLMS + meanLMS),zeros(3,1),ones(3,1))
% lms2rgb*(maxLMS*(-deltaLMS) + meanLMS)






