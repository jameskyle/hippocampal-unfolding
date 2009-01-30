%
%AUTHOR:  Engel
%DATE:  8/15/95
%PURPOSE:
%   This is a script to call the proper routines to create full field flckering
%	stimulus
%

nx = 192; ny = 192; 

angResolution = [1:360]/360;  	%steps around half circle

% Now, make a set of images that represent one cycle of the flickering
% polar checks.
% 
% There should be 2 images
numPatSteps = 2
radFunc = [-1*ones(1,1) ones(1,4) ...
           -1*ones(1,4) ones(1,4) ...
           -1*ones(1,8) ones(1,8) ...
           -1*ones(1,16) ones(1,16)];
radShift = 0;

% We make some reasonably large number of wedges in the pattern, and
% we move it at a shift that is comparable to the wedge shift.

pWedges = 6;

patAngFunc = square(2*pi*pWedges*angResolution);
pChecks = polarChecks([nx,ny,1],radFunc,0,patAngFunc,0);

s = scale(pChecks,1,254);
fixWidth = 3;
backColor = 0;
fixColor = 255;
for i=1:size(s,2)
 tmp = insertFixation(reshape(s(:,i),nx,ny),fixColor,backColor,fixWidth);
 s(:,i) = tmp(:);
end

colormap(gray(255));
displayMovie(s,nx,ny,numPatSteps,1,1)

% Create the data in a form usable on the Mac, though we still
% need to run convertsun2mac.m

bitimage=zerobitimage([nx,ny],size(s,2)+1);
tmp = insertFixation(127*ones(nx,ny),fixColor,backColor,fixWidth);
InsertBitImage255(tmp,bitimage,1);		% Blank screen
for i=1:size(s,2)
 InsertBitImage255(reshape(s(:,i),nx,ny),bitimage,i+1);
end
m = nx, n = ny, nimages = size(s,2)+1;

save '/home/engel/mac/newfullfield' bitimage m n nimages
