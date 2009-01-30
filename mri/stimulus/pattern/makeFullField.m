%
%AUTHOR:  Engel
%DATE:  8/15/95
%PURPOSE:
%   This is a script to call the proper routines to create full field flckering
%	stimulus
%

nx = 192; ny = 192; envResolution = 96;
envSteps = [0: (envResolution-1)]/(envResolution-1);
radStep = 0;
radFreq = 8;
radFunc = square(2*pi*radFreq*envSteps);
angFreq = 16;
angStep = 0;
angFunc = square(2*pi*angFreq*envSteps);
pChecks = polarChecks([nx, ny, 2],radFunc,radStep,angFunc,angStep);
  %colormap(gray(3));
  %displayMovie(pChecks+1,nx,ny, 2,1,1);

  s = scale(pChecks,1,254);
  fixWidth = 3;
  backColor = 0;
  fixColor = 255;
  for i=1:size(s,2)
   tmp = insertFixation(reshape(s(:,i),nx,ny),fixColor,backColor,fixWidth);
   s(:,i) = tmp(:);
  end

% Create the data in a form usable on the Mac, though we still
% need to run convertsun2mac.m

bitimage=zerobitimage([nx,ny],size(s,2)+1);
tmp = insertFixation(127*ones(nx,ny),fixColor,backColor,fixWidth);
InsertBitImage255(tmp,bitimage,1);		% Blank screen
for i=1:size(s,2)
 InsertBitImage255(reshape(s(:,i),nx,ny),bitimage,i+1);
end
m = nx, n = ny, nimages = size(s,2)+1;
save '/home/engel/mac/stimuli/resffield' bitimage m n nimages

