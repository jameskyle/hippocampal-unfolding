%
%AUTHOR:  Wandell
%DATE:    05.26.95
%PURPOSE:
%  Create a set of images of moving rings presented through an expanding
% envelope.  The envelope and the rings can be moving at different speeds
% and have different spatial frequencies.
%

colormap(gray(255));
nx = 64; ny = 64; envResolution = 64;
envSteps = [1: envResolution]/envResolution;

envFreq = 1;
envShift = -1;
envFunc = scale(square(2*pi*envFreq*envSteps),0,1);
env = circularWindow([nx ny envResolution],envFunc, envShift);
%displayMovie(env,nx,ny, envResolution,1,.1,'s');

relativeVelocity = -2;
ringShift = envShift*relativeVelocity;
ringFreq = 6;
ringFunc = scale(sin(2*pi*ringFreq*envSteps),0,1);
movingRings = circularWindow([nx ny envResolution],ringFunc,ringShift);
%displayMovie(movingRings,nx,ny, envResolution,1,.1,'s');

s = zeros(size(movingRings));
for i=1:envResolution
 s(:,i) = movingRings(:,i) .* env(:,i);
end
%displayMovie(s,nx,ny, envResolution,1,.1,'s'); 

fixWidth = 3;
backColor = 0;
fixColor = 1;
for i=1:size(s,2)
 tmp = insertFixation(reshape(s(:,i),nx,ny),fixColor,backColor,fixWidth);
 s(:,i) = tmp(:);
end
s = scale(s,1,254);
%displayMovie(s,nx,ny, envResolution,1,.1); 

bitimage=zerobitimage([nx,ny],size(s,2));
for i=1:size(s,2)
 InsertBitImage255(reshape(s(:,i),nx,ny),bitimage,i);
end
m = nx, n = ny, nimages = size(s,2);
save '/home/brian/mac/movingRings' bitimage m n nimages
