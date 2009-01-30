function pChecks = semipolarChecks(parms,radFunc,radStep,angFunc,angStep,orientation)
%
%   pChecks = polarChecks(nx,ny,nt,radFunc,radStep,angFunc,angStep)
%
%AUTHOR:  Wandell
%PURPOSE:
%  Create a series of images to serve in a rotating checks experiment
%
%  parms:     The spatial and temporal dimensions of the returned images, nx,ny,nt
%  radFunc:   The value as a function of radius
%  radStep:   Amount to shift the radFunc in each image
%  angFunc:   The value as a function of angle
%  angStep:   Amount to shift the angFunc in each image
%
%  The actual value in a polar check is radFunc * angFunc
%
%  pChecks:   The set of images
%

nx = parms(1);
ny = parms(2);
nt = parms(3);

[xdistances ydistances] = meshgrid(1:nx,1:ny);
xdistances = xdistances - (nx/2);
ydistances = ydistances;
if (orientation == 'd');
  ydistances = flipud(ydistances);
end

%  Create the quantized polar coordinate representation
nRad = length(radFunc);
r = sqrt(xdistances.^2 + ydistances.^2);
corner = find(r > min(nx/2,ny));
r(corner) = zeros(1,length(corner));
qr = setQuantization(r,nRad);

nAng = length(angFunc);
theta = atan2(ydistances,xdistances);
qtheta = setQuantization(theta,nAng);

angLocs = 0:(length(angFunc)-1);
radLocs = 0:(length(radFunc)-1);
dubAngFunc = [angFunc angFunc];
dubRadFunc = [radFunc radFunc];
dubAnglocs = 1:length(dubAngFunc);
dubRadlocs = 1:length(dubRadFunc);
pChecks = zeros(nx*ny,nt);
z = zeros(length(corner),1);
for i=1:2:nt
 currentAngFunc = interp1(dubAnglocs, dubAngFunc, angLocs+1);
 currentRadFunc = interp1(dubRadlocs, dubRadFunc, radLocs+1);
 angLocs = angLocs+angStep;
 angLocs = mod(angLocs,length(angFunc));
 radLocs = radLocs+radStep;
 radLocs = mod(radLocs,length(radFunc));
 pChecks(:,i) = (currentAngFunc(qtheta) .* currentRadFunc(qr));
 pChecks(corner,i) = z;
 pChecks(:,i+1) = -pChecks(:,i);
 disp(i);
end


% sn = 1-2*mod(i,2);
% pChecks(:,i) = sn*(currentAngFunc(qtheta) .* currentRadFunc(qr));

%currentAngFunc = angFunc;
%currentRadFunc = radFunc;
%pChecks = zeros(nx*ny,nt);
%z = zeros(length(corner),1);
%for i=1:2:nt
% pChecks(:,i) = (currentAngFunc(qtheta) .* currentRadFunc(qr))';
% pChecks(:,i+1) = -1*pChecks(:,i);
% pChecks(corner,i) = z;
% pChecks(corner,i+1) = z;
% We rotate by half of i because the two flickered images
% should be at the same position
% currentAngFunc = vecRotate(angFunc,round( (i/2)*angStep));  
% currentRadFunc = vecRotate(radFunc,round( (i/2)*radStep));  
% sprintf('Images remaining: %d',nt - i)
%end
