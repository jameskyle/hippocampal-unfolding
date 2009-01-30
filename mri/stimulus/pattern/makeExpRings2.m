%
%AUTHOR:  Wandell
%DATE:    05.26.95
%PURPOSE:
%  Create a set of images of moving rings presented through an expanding
% envelope.  The envelope and the rings can be moving at different speeds
% and have different spatial frequencies.
%

colormap(gray(255));
%nx = 192; ny = 192; envResolution = 128;
nx = 48; ny = 48; envResolution = 48;
envSteps = [1: envResolution]/envResolution;

envFreq = 1;
envShift = -1;
envFunc = scale(square(2*pi*envFreq*envSteps),0,1);
env = circularWindow([nx ny envResolution],envFunc, envShift);
%displayMovie(env,nx,ny, envResolution,1,.1,'s');

radFreq = 4;
radStep = 0;
radFunc = [-1*ones(1,1) ones(1,1) ...
           -1*ones(1,2) ones(1,2) ...
           -1*ones(1,4) ones(1,4) ...
           -1*ones(1,8) ones(1,8) ...
           -1*ones(1,16) ones(1,16)];
angFreq = 16;
angStep = 0;
angFunc = square(2*pi*angFreq*envSteps);
checks = polarChecks([nx ny envResolution],radFunc,radStep,angFunc,angStep);
%displayMovie(checks,nx,ny, envResolution,1,.1,'s');

s = zeros(size(checks));
for i=1:envResolution
 s(:,i) = checks(:,i) .* env(:,i);
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

save '/home/brian/mac/expRings' bitimage m n nimages

%
%  Now, make a seq variable that lists the cmaps and the frame
%  numbers.  Remember, the frame rate is 66.67 frames per second.
%
