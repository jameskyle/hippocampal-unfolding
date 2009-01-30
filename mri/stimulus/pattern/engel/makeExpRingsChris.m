%
%AUTHOR:  Wandell
%DATE:    05.26.95
%PURPOSE:
%  Create a set of images of moving rings presented through an expanding
% envelope.  The envelope and the rings can be moving at different speeds
% and have different spatial frequencies.
%

nx = 300; ny = 300; envResolution = 96;
envSteps = [0: (envResolution-1)]/(envResolution-1);

envFreq = 2;
envFunc = scale(square(2*pi*envFreq*envSteps),0,1);
env = circularWindow(envFunc,nx,ny,envResolution/envFreq,1,'r');
%colormap(gray(2));
%displayMovie(env+1,nx,ny, envResolution/envFreq,1,1);

radStep = 0;
radFreq = 6;
radFunc = square(2*pi*radFreq*envSteps);

angFreq = 16;
angStep = 0;
angFunc = square(2*pi*angFreq*envSteps);
checks = polarChecks([nx, ny, envResolution/envFreq], ...
			radFunc,radStep,angFunc,angStep);
%displayMovie(checks+1,nx,ny, envResolution/envFreq,1,1);
s = zeros(size(checks));
for i=1:2:envResolution/envFreq
 s(:,i) = checks(:,i) .* env(:,i);
 s(:,i+1) = checks(:,i+1) .* env(:,i);
end
%displayMovie(s+1,nx,ny, envResolution/envFreq,1,.1); 

fixWidth = 3;
backColor = 0;
fixColor = 1;
for i=1:size(s,2)
  tmp = insertFixation(reshape(s(:,i),nx,ny),fixColor,backColor,fixWidth);
  s(:,i) = tmp(:);
end
s = scale(s,1,254);
estr = ['save ''/home/engel/mac/stimuli/tmpRings',... 
	num2str(envFreq),''' s nx ny'];
eval(estr);

break

  envFreq = 2;
  estr = ['load ''/home/engel/mac/stimuli/tmpRings',... 
		num2str(envFreq),''''];
  eval(estr);
  bitimage=zerobitimage([nx,ny],size(s,2));
  for i=1:size(s,2)
    InsertBitImage255(reshape(s(:,i),nx,ny),bitimage,i);
  end
  m = nx, n = ny, nimages = size(s,2);

  estr = ['save ''/home/engel/mac/stimuli/chrisRings',... 
		num2str(envFreq),''' bitimage m n nimages'];
  eval(estr);

 


