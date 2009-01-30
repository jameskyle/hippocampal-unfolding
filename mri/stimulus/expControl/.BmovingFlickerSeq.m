function seq = movingFlickerSeq(nLevels,freq,dur,frameRate,...
	nSamples,sRange,sSpacing, sVelocity)
%
%AUTHOR:  Wandell
%DATE:
%PURPOSE:

% Sequence properties
% nLevels = 2;
% freq = 8;
% dur = 1;
% frameRate = 66.7;

seq = flickerSeq(nLevels,freq,dur,frameRate);

% Sample properties
%
% nSamples = 8;	% Total
% sRange = 1   	% deg
% sSpacing = sRange/nSamples
% sVelocity = 2;  % deg/sec

% sVelocity = sSpacing/sampleTiming
%
sampleTiming = sSpacing/sVelocity	%In seconds

l = [1:length(seq)]/frameRate;
l = mod(floor(l/sampleTiming),nSamples);
plot(l)

seq = seq - 1;
seq = l .* seq;
% plot(seq)

return
