% Flicker properties
%
freq = 2;
dur = 10;
frameRate = 66.7;

% Sample motion properties
%
nSamples = 8;	% Total
sRange = 1   	% deg
sVelocity = 1;  % deg/sec

seq = movingFlickerSeq(freq,dur,frameRate,nSamples,sRange,sVelocity);
plot(seq)
