%
% Make color maps for sinusoidal modulation of the Gabor patches
% in the spatial frequency experiment.
%
changeDir('/home/brian/matlab/mri/stimulus/color')

load sanyoLCD
displayP = sanyoLCD;
plot(displayP)
load sanyoLCDGam
invGamma = sanyoLCDGamInv;

load ncones
cones = spCones;
rgb2lms = cones'*displayP;
lms2rgb = inv(rgb2lms);
mpData = [256 2 255];

% Choose [.5 .5 .5] rgb level as mean.
meanLMS = rgb2lms*[.5 .5 .5]';


deltaLMS1 = [1 1 0]';
[maxLMS1,meanRGB]=maxConeContrast(meanLMS,deltaLMS,displayP,cones);

deltaLMS2 = [1 -1 0]';
[maxLMS2,meanRGB]=maxConeContrast(meanLMS,deltaLMS,displayP,cones);

maxContrastLMS = min(maxLMS1, maxLMS2);

contrastLMS = maxContrastLMS*sin(2*pi*[0:31]/32);

cmap1 = buildLinearMaps(deltaLMS1,meanLMS,contrastLMS, mpData,lms2rgb);
cmap2 = buildLinearMaps(deltaLMS2,meanLMS,contrastLMS, mpData,lms2rgb);
cmap = [ cmap1 , cmap2];

save cmap110496 cmap mpData meanLMS deltaLMS1 deltaLMS2 contrastLMS lms2rgb displayP cones

%
%
return

f = 4;
im = cos(2*pi*f*[1:128]/128);
im = im(ones(64,1),:);
g = mkGaussKernel(size(im),[16 32]);
g = g / mmax(g);
im = scale(im .* g,2,255);
image(im);

% To adjust the contrast over time, switch the color maps as in
%
for i=1:64
%  n = mod(i-1,32) + 1
  n = (mod(i-1,32) + 1)
  col = (n-1)*3 + 1 + 96
  colormap(cmap(:,col:col+2))
  pause(0.1)
end
