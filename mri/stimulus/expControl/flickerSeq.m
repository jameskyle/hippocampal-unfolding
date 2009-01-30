function seq = flickerSeq(nContrastLevels,stimulusFreq,stimulusDur,displayFreq)
%
% seq = flickerSeq(nContrastLevels,stimulusFreq,stimulusDur,displayFreq)
%
%AUTHOR: Baseler, Wandell
%DATE:   11.11.96
%PURPOSE:
%
%  This routine creates a flickering pattern based on color map
%  animation.  We select a set of contrast levels that vary over
%  time in order to create a flickering image.
% 
%  The returned seq is always positive, and if it is to be used
% for look-up table animation, then the user should set it to be
% negative.
%
%ARGUMENTS:
% nContrastLevels:  the number of contrast levels present in
% 	the color maps or contrast images for a single cycle of
% 	the stimulus 
% 
% stimulusFreq:  the stimulus flicker rate desired (Hz)
% stimulusDur:	 the stimulus duration for the flicker (secs)
% displayFreq:   the display frame rate (default:  66.666)
% 
%RETURNS:
% seq:  A sequence of values that define which color map to use
% 	for each frame display.
% 

% nContrastLevels = 4
% stimulusFreq = 3
% stimulusDur = 3
% displayFreq = 66.666

if nargin < 4
  displayFreq = 200/3;
end

if stimulusFreq ~= round(stimulusFreq)
  disp('We are worried:  stimulusFreq should be an integer')
end

% To make things time out properly, we don't necessarily use all
% of the input contrast levels
%
nFramesPerDuration = round(displayFreq*stimulusDur);
seq = linspace(0,nContrastLevels*stimulusFreq*stimulusDur,nFramesPerDuration);
seq = floor(mod(seq,nContrastLevels)) + 1;

return
