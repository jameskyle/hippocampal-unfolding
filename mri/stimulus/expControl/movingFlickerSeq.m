function seq = movingFlickerSeq(freq,dur,frameRate,...
	nSamples,sRange,sVelocity)
%
% function seq = movingFlickerSeq(nLevels,freq,dur,frameRate,...
%	nSamples,sRange,sSpacing, sVelocity)
%
%AUTHOR:  Wandell
%DATE:    12.04.96
%PURPOSE:
%  Make a sequence to describe a set of moving patterns that are
% also flickering.  The flicker rate and the motion parameters
% are distinct
%
%ARGUMENTS:
% freq (Hz)
% dur (sec)
% frameRate (frames/sec)
% nSamples (integer)
% sRange (deg)
% sSpacing (deg)
% sVelocity (deg/sec)

% Sequence properties
% freq = 8;
% dur = 1;
% frameRate = 66.7;
%
% Sample properties
%
% nSamples = 8;	% Total
% sRange = 1   	% deg
% sVelocity = 2;  % deg/sec

% Start out with a sequence assuming a blank and stimulus, hence
% two levels
%
nLevels = 2;
seq = flickerSeq(nLevels,freq,dur,frameRate);

% sVelocity = sSpacing/sampleDuration
% So, the timing before a change from sample position to the
% next can be computed as
%
sSpacing = sRange/nSamples
sampleDuration = sSpacing/sVelocity;	%In seconds

l = [1:length(seq)]/frameRate;
l = mod(floor(l/sampleDuration),2*nSamples);
list = find(l >= (nSamples));
l(list) = 2*nSamples - l(list);
l = l + 1;

% plot(l)
% max(l), min(l)


seq = seq - 1;
seq = l .* seq;
seq = seq + 1;

% plot(seq)

return
