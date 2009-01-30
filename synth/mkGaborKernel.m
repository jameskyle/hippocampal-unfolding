function gabor = mkGaborKernel(kernelSize,sd,freq,ph)
%  kernel = mkGaussKernel(kernelSize,sd,freq,ph)
%
%	Create a Gabor kernel.  One-D. Gaussian has standard deviation sd 
%       and sinusoid has frequency freq, and phase ph in radians.
%

halfrange = round(kernelSize/2);
locs = [-halfrange:halfrange];
gauss = exp(-0.5*(locs/sd).^2);
gauss = gauss / sum(gauss);
gabor = gauss.*sin((locs/length(locs))*freq*2*pi + ph);

