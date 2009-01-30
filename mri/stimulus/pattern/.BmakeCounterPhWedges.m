%
%AUTHOR:  Engel
%DATE:  8/1/95
%PURPOSE:
%   This is a script to call the proper routines to create 4
%   images for the Tootel-style conterphase flickering wedge stimulus.
%

% First, make the wedge window with 2 wedges.  We'll make two stimuli, one 
% for vertical and one for horizontal meridia. Each wedge is 45 deg with
% (3*45) deg between them.  The big blank space is so that when the stimulus
% rotates to the other meridia there is still some blank non-stimulated space.
% 


nx = 192; ny = 192; 
numEnvSteps = 2;
angResolution = [1:360]/360;  	%steps around whole circle
wedgeCycles = 2;		%cycles per circle

wedgeAngFunc = square(2*pi*wedgeCycles*angResolution+pi/4,25);  % Vertical
wedgeAngFunc = scale(wedgeAngFunc,0,1);
plot(wedgeAngFunc);

% Move the envlope around one cycle in numEnvSteps
wedgeShift = 90;
w = wedgeWindow(wedgeAngFunc,nx,ny,numEnvSteps,wedgeShift);

colormap(gray(255)), displayMovie(scale(w,1,255),nx,ny, numEnvSteps)

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
plot(radFunc);

% We make some reasonably large number of wedges in the pattern, and
% we move it at a shift that is comparable to the wedge shift.
pWedges = 16;
relVelocity = 1;
patAngShift = relVelocity * wedgeShift;
patAngFunc = square(2*pi*pWedges*angResolution);

pChecks = polarChecks([nx,ny,numPatSteps],radFunc,radShift,patAngFunc,patAngShift);
displayMovie(scale(pChecks,1,255),nx,ny,numPatSteps,1)

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
backColor = 0;
fixColor = 255;
for i=1:size(s,2)
 tmp = insertFixation(reshape(s(:,i),nx,ny),fixColor,backColor,fixWidth);
 s(:,i) = tmp(:);
end

displayMovie(s,nx,ny,numPatSteps,1,1)

% Create the data in a form usable on the Mac, though we still
% need to run convertsun2mac.m

bitimage=zerobitimage([nx,ny],size(s,2)+1);
tmp = insertFixation(128*ones(nx,ny),fixColor,backColor,fixWidth);
InsertBitImage255(tmp,bitimage,1);		% Blank screen
for i=1:size(s,2)
 InsertBitImage255(reshape(s(:,i),nx,ny),bitimage,i+1);
end
m = nx, n = ny, nimages = size(s,2)+1;
save '/home/engel/mac/wedges' bitimage m n nimages


