%
%AUTHOR:  Wandell
%DATE:    05.26.95
%PURPOSE:
%  Create a set of images of moving rings presented through an expanding
% envelope.  The envelope and the rings can be moving at different speeds
% and have different spatial frequencies.
%

nx = 200; ny = 100; envResolution = 50;
envSteps = [0: (envResolution-1)]/(envResolution-1);
envFreq = 1;

envFunc = scale(square(2*pi*envFreq*envSteps),0,1); 
env = barWindow(envFunc,nx,ny,envResolution/envFreq,1,'r');
%colormap(gray(2));
%displayMovie(env+1,ny,nx, envResolution/envFreq,1,1);

checkSteps = [1: (ny-1)]/(ny-1);
xStep = 0;
xFreq = 10;
xFunc = square(2*pi*xFreq*checkSteps);
yStep = 0;
yFreq = 5;
yFunc = square(2*pi*yFreq*checkSteps);

checks = standardChecks([nx, ny, envResolution/envFreq], ...
			xFunc,xStep,yFunc,yStep);
%displayMovie(checks+1,ny,nx, envResolution/envFreq,1,1);

s = zeros(size(checks));
for i=1:2:envResolution/envFreq
   s(:,i) = checks(:,i) .* env(:,i);
   s(:,i+1) = checks(:,i+1) .* env(:,i);
end
%displayMovie(s+1,ny,nx, envResolution/envFreq,1,.1); 

%fixWidth = 3;
%backColor = 0;
%fixColor = 1;
%for i=1:size(s,2)
%    tmp = insertFixation(reshape(s(:,i),ny,nx),fixColor,backColor,fixWidth);
%    s(:,i) = tmp(:);
%end
s = scale(s,1,254);

bitimage=zerobitimage([ny,nx],size(s,2));
for i=1:size(s,2)
    InsertBitImage255(reshape(s(:,i),ny,nx),bitimage,i);
end
m = ny, n = nx, nimages = size(s,2);

estr = ['save ''/home/engel/mac/stimuli/moveBars',... 
		num2str(envFreq),''' bitimage m n nimages'];
eval(estr);
 


