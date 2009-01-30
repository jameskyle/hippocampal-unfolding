%
%AUTHOR:  Engel
%DATE:  8/1/95
%PURPOSE:
%   This is a script to call the proper routines to create 4
%   images for the Tootel-style conterphase flickering wedge stimulus.
%

% First, make the wedge window with 2 wedges.  We'll make two stimuli, one 
% for vertical and one for horizontal meridia.  Vertical wedges are 60 and 
% horizontal wedges are 30 degrees of arc.
% 


nx = 192; ny = 192; 

angResolution = [1:360]/360;  	%steps around half circle
wedgeCycles = 2;		%cycles per circle

wedgeAngFunc = square(2*pi*wedgeCycles*angResolution,33.33);  % Vertical
wedgeAngFunc = vecRotate(wedgeAngFunc,120);
wedgeAngFunc = scale(wedgeAngFunc,0,1);
wvert = wedgeWindow(wedgeAngFunc,nx,ny,1,0);
%colormap(gray(255)), displayMovie(scale(wvert,1,255),nx,ny, 1)

wedgeAngFunc = square(2*pi*wedgeCycles*angResolution,100*(1/6));  % Horizontal
wedgeAngFunc = vecRotate(wedgeAngFunc,15);
wedgeAngFunc = scale(wedgeAngFunc,0,1);
whor = wedgeWindow(wedgeAngFunc,nx,ny,1,0);


numEnvSteps = 2;
w = [wvert whor];

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

pWedges = 12;
relVelocity = 1;
patAngShift = 90;

patAngFunc = square(2*pi*pWedges*angResolution);
pChecks1 = polarChecks([nx,ny,1],radFunc,radShift,patAngFunc,0);

patAngFunc = square(2*pi*pWedges*angResolution);
patAngFunc = vecRotate(patAngFunc,15);
pChecks2 = polarChecks([nx,ny,1],radFunc,radShift,patAngFunc,0);
pChecks = [pChecks1 pChecks2];

%displayMovie(scale(pChecks,1,255),nx,ny,numPatSteps,1)
%hold on, plot([1,nx],[ny/2,ny/2],'r-'), hold off
% Now, make one complete cycle of the stimulus by multiplying the window
% times the stimulus.  
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
