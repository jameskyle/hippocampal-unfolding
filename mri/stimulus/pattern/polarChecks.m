function pChecks = polarChecks(parms,radFunc,radStep,angFunc,angStep)
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

%nx = 64, ny= 64, nt = 16;
%nRings = 4;
%nWedges = 1;
%radFunc = square(2*pi*nRings*[0:.02:1]);
%angFunc = square(2*pi*nWedges*[0:.02:1]);
%radStep = 1;
%angStep = 1;

[xdistances ydistances] = meshgrid(1:nx,1:ny);
xdistances = xdistances - (nx/2);
ydistances = ydistances - (ny/2);

%  Create the quantized polar coordinate representation
nRad = length(radFunc);
r = sqrt(xdistances.^2 + ydistances.^2);


% There is something wrong here, so I stuck in the
corner = find(r > min(nx/2,ny/2));
if (min(corner) < 1)
  error('corner < 1')
end


qr = setQuantization(r,nRad);

nAng = length(angFunc);
theta = atan2(ydistances,xdistances);
qtheta = setQuantization(theta,nAng);

currentAngFunc = angFunc;
currentRadFunc = radFunc;
pChecks = zeros(nx*ny,nt);
z = zeros(length(corner),1);

% 
for ii=1:2:nt
 pChecks(:,ii) = (currentAngFunc(qtheta(:)) .* currentRadFunc(qr(:)))';
 pChecks(:,ii+1) = -1*pChecks(:,ii);
 pChecks(corner,ii) = z;
 pChecks(corner,ii+1) = z;

 % We rotate by half of i because the two flickered images
 % should be at the same position
 currentAngFunc = vecRotate(angFunc,round( (ii/2)*angStep));  
 currentRadFunc = vecRotate(radFunc,round( (ii/2)*radStep));  
 sprintf('Images remaining: %d',nt - ii)
end
