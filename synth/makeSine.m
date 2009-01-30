function [res] = makeSine(sz, period, dir, amplitude, phase, origin)
% res = makeSine([ydim xdim], period, direction, amplitude, phase, origin)
%
% Compute a matrix containing samples of a 2D sinusoid, with given PERIOD
% (pixels), DIRECTION (radians, default 0), AMPLITUDE (default 1), PHASE
% (radians, relative to ORIGIN, default 0), and ORIGIN (default [1 1]).
%
% EPS, 6/96.

%% TODO: allow a 2-vector frequency spec instead of period/dir.

if (exist('dir') ~= 1)
  dir = 0;
end

if (exist('amplitude') ~= 1)
  amplitude = 1;
end

if (exist('phase') ~= 1)
  phase = 0;
end
 
if (exist('origin') ~= 1)
  origin = [1 1];
end

ramp = makeRamp(sz, dir, 2*pi/period, phase, origin);

res = amplitude * sin(ramp);
