% Test the various routines for building harmonic maps.

load sanyoLCD
displayP = sanyoLCD;
plot(displayP)
load sanyoLCDGam
invGamma = sanyoLCDGamInv;

load ncones
cones = spCones;
rgb2lms = cones'*displayP;
lms2rgb = inv(rgb2lms);

[maxContrastLMS,meanRGB]=maxConeContrast(meanLMS,deltaLMS,displayP,cones);

% Check that we are at a boundary on one end
% lms2rgb*(meanLMS + maxContrastLMS*deltaLMS)
% lms2rgb*(meanLMS - maxContrastLMS*deltaLMS)

% 
% Set the contrasts relative to the maximum permissible
% 

% If you are working with a harmonic function and you want to
% adjust its contrast, frequency and phase over time without
% bit-blitting, you can use this type of look-up table animation.
%
mpData =   [ 128 ];
mapFreq = [ 2 ];
mapPh = ([ 1:10 ]/10)*pi;
meanLMS = rgb2lms*[.5 .5 .5]';
deltaLMS = [0 0 1]';
contrastLMS = maxContrastLMS*[1]
[rgbMap parameters] = ...
    buildHarmonicMaps(deltaLMS,meanLMS,contrastLMS, ...
    mpData,mapFreq,mapPh,lms2rgb);

checkRange(rgbMap(:),0,1)

% Then, to make the function shift over time, do this
im = 1:nValues;
im = im(ones(64,1),:);
image(im)

for i = 1:length(mapPh)
 col = (i-1)*3 + 1
 colormap(rgbMap(:,col:col+2))
 pause(1)
end


% This is how to make a general one-dimensional stimulus that is
% fixed in position and modulate its contrast.
% Use linear color maps with different peak contrast levels.
%
mpData =   [ 128 ];
meanLMS = rgb2lms*[.5 .5 .5]';deltaLMS = [0 0 1]';
contrastLMS = maxContrastLMS*[.2 .5 1]
rgbMap = buildLinearMaps(deltaLMS,meanLMS,contrastLMS, mpData,lms2rgb);

f = 4;
im = cos(2*pi*f*[1:128]/128);
im = scale(im,1,128);
im = im(ones(64,1),:);
g = mkGaussKernel(size(im),[16 32]);
g = g / mmax(g);
im = im .* g;
image(im);

% To adjust the contrast over time, switch the color maps as in
%
for i=1:length(contrastLMS)
  col = (i-1)*3 + 1
  colormap(rgbMap(:,col:col+2))
  pause(2)
end


