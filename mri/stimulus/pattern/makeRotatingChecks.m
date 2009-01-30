%
%AUTHOR:  Wandell
%DATE:  5.25.95
%PURPOSE:
%   This is a script to call the proper routines to create a
% set of images for the flickering/rotating check stimulus.
%

% First, make the wedge window with 3 wedges.
% The angular function has a frequency of 3.  We want to take 48 steps
% to reach the first point at which it maps into itself.
nx = 192; ny = 192; 
numEnvSteps = 24;
angResolution = [1:360]/360;  	%steps around whole circle
wedgeCycles = 3;		%cycles per circle


wedgeAngFunc = square(2*pi*wedgeCycles*angResolution);
wedgeAngFunc = scale(wedgeAngFunc,0,1);

% Move the envlope around one cycle in numEnvSteps
wedgeShift = (360/wedgeCycles)/numEnvSteps;	
w = wedgeWindow(wedgeAngFunc,nx,ny,numEnvSteps,wedgeShift);

%colormap(gray(255)), displayMovie(scale(w,1,255),nx,ny, numEnvSteps)

% Now, make a set of images that represent one cycle of the flickering
% polar checks.
% 
% There should be 2 images for each wedge position
numPatSteps = 2*numEnvSteps;
radFunc = [-1*ones(1,1) ones(1,1) ...
           -1*ones(1,2) ones(1,2) ...
           -1*ones(1,4) ones(1,4) ...
           -1*ones(1,8) ones(1,8) ...
           -1*ones(1,16) ones(1,16)];
radShift = 0;

% We make some reasonably large number of wedges in the pattern, and
% we move it at a shift that is comparable to the wedge shift.
pWedges = 16;
relVelocity = 1;
patAngShift = relVelocity * wedgeShift;
patAngFunc = square(2*pi*pWedges*angResolution);

pChecks = polarChecks([nx,ny,numPatSteps],radFunc,radShift,patAngFunc,patAngShift);
%displayMovie(scale(pChecks,1,255),nx,ny,numPatSteps,1)

% Now, make one complete cycle of the stimulus by multiplying the window
% times the stimulus.  Since the window moves 1 step per second, and the
% pChecks flicker 4 times per second, we multiply each window times four
% pCheck pictures.
%
s = zeros(size(pChecks));
for i=1:size(w,2)
 currentW = w(:,i);
 next = 2*(i-1) + 1;
 for j = [next:next+1]
  s(:,j) = currentW .* pChecks(:,j);
  j
 end
end
s = scale(s,1,254);

fixWidth = 3;
backColor = 1;
fixColor = 254;
for i=1:size(s,2)
 tmp = insertFixation(reshape(s(:,i),nx,ny),fixColor,backColor,fixWidth);
 s(:,i) = tmp(:);
end

%displayMovie(w,nx,ny,numEnvSteps,1)
%displayMovie(pChecks,nx,ny,numPatSteps,1)
%displayMovie(s,nx,ny,numPatSteps,1,1)

% Create the data in a form usable on the Mac, though we still
% need to run conversun2mac.m
bitimage=zerobitimage([nx,ny],size(s,2));
for i=1:size(s,2)
 InsertBitImage255(reshape(s(:,i),nx,ny),bitimage,i);
end
m = nx, n = ny, nimages = size(s,2);
save '/home/brian/mac/rotWedge' bitimage m n nimages

% Now, make a list of the frame sequences parameters.
% Each frame should be on for one-half cycle at 4Hz.
framesPerSec = 67;
flickerRate = 4;
frameDuration = round(framesPerSec/(2*flickerRate));

% We want to pass through all 48 frames in 24 seconds.
% Hence, we shift from alternating between frames 1-2, to 2-3 after 1 sec.
% Thus, we alternate 4 times between 1-2,  
nFramesPerEnvStep = 8;
frameSequence = zeros(1,numEnvSteps*nFramesPerEnvStep);
pattern = [ 1 2 1 2 1 2 1 2];
for i=1:24
 rng = [8*(i-1):8*i - 1] + 1;
 frameSequence(rng) = pattern + (i-1)*2;
end

% We will repeat this sequence 8 times.
nSeq = 8;
save '/home/brian/mac/rotWedgeParms' frameSequence nSeq frameDuration
