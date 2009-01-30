%script
% 
%AUTHOR:  Wandell
%DATE:    05.26.95
%PURPOSE:
%  Create a set of images of moving rings presented through an expanding
% envelope.  The envelope and the rings can be moving at different speeds
% and have different spatial frequencies.
%

% Set up the envelope that we will see through for the flickering
% checks.  It has 3 cycles around the circle in this case.
%
nx = 120; ny = 120; envResolution = 120;
envSteps = [0: (envResolution-1)]/(envResolution-1);
envFreq = 1;

envFunc = [zeros(size(envSteps))];
on = length(envSteps)/4;
envFunc(1:on) = ones(1,on);
plot(envFunc)

% 
% envFunc = scale(square(2*pi*envFreq*envSteps),0,1); 
env = wedgeWindow(envFunc,nx,ny,envResolution/envFreq,1);

% colormap(gray(2));
% displayMovie(env+1,nx,ny, envResolution/envFreq,1,1);

% Define the radial function for the checks
%
radStep = 0;
radFreq = 4;
radFunc = square(2*pi*radFreq*envSteps);

% Define the angular function for the checks
angFreq = 6;
angStep = 0;
angFunc = square(2*pi*angFreq*envSteps);

checks = polarChecks([nx, ny, envResolution/envFreq], ...
			radFunc,radStep,angFunc,angStep);
% displayMovie(checks+1,nx,ny, envResolution/envFreq,1,1);

s = zeros(size(checks));
for ii=1:2:envResolution/envFreq
   s(:,ii) = checks(:,ii) .* env(:,ii);
   s(:,ii+1) = checks(:,i+1) .* env(:,ii);
end
% colormap(gray(2)), displayMovie(s+1,nx,ny, envResolution/envFreq,1,.1); 

% changeDir('/home/brian/slides/mri/Stimuli/Wedge');
% mp = gray(3);
% for ii = 1:30:120
%  X = reshape(s(:,ii) + 2,nx,ny);
%  fname = sprintf('wedge%.0f.tif',ii);
%  imwrite(X,mp,fname,'tif');
% end
% unix('xv wedge*.tif & ');

fixWidth = 3;
backColor = 0;
fixColor = 1;
for i=1:size(s,2)
  tmp = insertFixation(reshape(s(:,i),nx,ny),fixColor,backColor,fixWidth);
  s(:,i) = tmp(:);
end
s = scale(s,1,254);

bitimage=zerobitimage([nx,ny],size(s,2));
for i=1:size(s,2)
    InsertBitImage255(reshape(s(:,i),nx,ny),bitimage,i);
end
m = nx, n = ny, nimages = size(s,2);

estr = ['save ''/home/engel/mac/stimuli/rotWedges',... 
		num2str(envFreq),''' bitimage m n nimages'];
eval(estr);
 


