function sChecks = standardChecks(parms,xFunc,xStep,yFunc,yStep)
%
% sChecks = standardChecks(parms,xFunc,xStep,yFunc,yStep)
%
%AUTHOR:  Wandell
%PURPOSE:
%  Create a series of images to serve in a moving bars experiment
%
%  parms:     The spatial and temporal dimensions of the returned images, nx,ny,nt
%  xFunc:   The value as a function of x
%  xStep:   Amount to shift the xFunc in each image
%  yFunc:   The value as a function of y
%  yStep:   Amount to shift the yFunc in each image
%
%  The actual value in a polar check is xFunc * yFunc
%
%  pChecks:   The set of images
%

nx = parms(1);
ny = parms(2);
nt = parms(3);

[xdistances ydistances] = meshgrid(1:nx,1:ny);
xdistances = xdistances - (nx/2);
ydistances = ydistances - (ny/2);

%  Create the quantized polar coordinate representation
numx = length(xFunc);
qx = setQuantization(xdistances,numx);
numy = length(yFunc);
qy = setQuantization(ydistances,numy);

xLocs = 0:(length(xFunc)-1);
yLocs = 0:(length(yFunc)-1);
dubxFunc = [xFunc xFunc];
dubyFunc = [yFunc yFunc];
dubxlocs = 1:length(dubxFunc);
dubylocs = 1:length(dubyFunc);
sChecks = zeros(nx*ny,nt);
for i=1:2:nt
 currentxFunc = interp1(dubxlocs, dubxFunc, xLocs+1);
 currentyFunc = interp1(dubylocs, dubyFunc, yLocs+1);
 xLocs = xLocs+xStep;
 xLocs = mod(xLocs,length(xFunc));
 yLocs = yLocs+yStep;
 yLocs = mod(yLocs,length(yFunc));
 sChecks(:,i) = (currentxFunc(qx) .* currentyFunc(qy));
 sChecks(:,i+1) = -sChecks(:,i);
 disp(i);
end


