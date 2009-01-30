%
%	This shows how to create the expanding rings
% 

cd /home/brian/exp/mri/stimuli

nx = 128;
ny = 128;
direction = 'r';
maxDistance = nx/2;
nspcyc = 2;
spstep = (2*pi*nspcyc)/maxDistance;
splocs = [spstep:spstep:(2*pi*nspcyc)];     % Position of windowing function (pixels)
shiftStep = .175;			       % How far to move between frames (pixels)
nt = floor(((length(splocs)-1)/nspcyc)/shiftStep);	       % So get one complete cycle

spatialFilter = mkGaussKernel([.25*nx .25*ny],[.05*nx 0.05*ny]);
temporalFilter = mkGaussKernel( [1 0.25*nt/nspcyc], [1 0.1*nt/nspcyc]);
spwindowfun = scale(convolvecirc(square(splocs), temporalFilter),0,1);

window = makeCircularWindow(spwindowfun,nx,ny,nt,shiftStep,direction);
noise = makeFilteredNoise(nx,ny,nt, spatialFilter, temporalFilter);

save basicstimparts window noise nx ny nt

wgt = 255;
noise = scale(noise,0,wgt);
stim = noise .* window;
for i = 1:nt
	img = reshape(stim(:,i),nx,ny);
	poo = getfix(img,0,255,0);
	stim(:,i) = reshape(poo,nx*ny,1);
end

% What do we want to do?

%   1.  We have our index values coded as linear contrast in the indexed
%       image
%   2.  We want to convert the colormap so that when we use those
%       framebuffer values, we achieve the linear intensities represented
%       in the indexed image.
%
%   For example, when we have an indexed (linear) image ranging from 0-1,
%   then we want the index value that represents the linear 0.5 to generate 
%   an output that is at one-half of the max of the monitor.  The size of the
%   color map shouldn't matter.
%
%	1.  The gamma tables must be checked for monotonicity.
%	2.  We should create an inverse gamma table and save the two
%		two of them together.
%	3.  We could do polynomial fitting to the maps and augment the
%		map handling by using an implicit power-function model both
%		for describing the map and its inverse.
%

load sanyoLCDGam	%Load the relevant gamma function
load sanyoLCD
load /home/brian/matlab/cap/xyz
desiredxyz = [.0548, .0548, .0548]';
mon2xyz = XYZ'*sanyoLCD;
xyz2mon = inv(mon2xyz);
linwhite = xyz2mon*desiredxyz;

%plot(sanyoLCD*linwhite);

linearmap = gray(256);
redmp = linearmap * [1 0 0; 0 0 0; 0 0 0 ];
greenmp = linearmap * [0 0 0; 0 1 0; 0 0 0 ];
bluemp = linearmap * [0 0 0; 0 0 0; 0 0 1 ];
basemap = ones(256,1)*linwhite';
redstart = linwhite(1);
redrange = 1-redstart;
greenstart = linwhite(2);
greenrange = 1-greenstart;
bluestart = linwhite(3);
bluerange = 1-bluestart;

redhimp = redrange*redmp+basemap;
redhimp = map2map(redhimp,sanyoLCDGamInv/255);
cyanmidmp = .7*greenrange*greenmp+.7*bluerange*bluemp+basemap;
cyanmidmp = map2map(cyanmidmp,sanyoLCDGamInv/255);
cyanhimp = greenrange*greenmp+bluerange*bluemp+basemap;
cyanhimp = map2map(cyanhimp,sanyoLCDGamInv/255);
mix1mp = redrange*redmp+.7*greenrange*greenmp+.7*bluerange*bluemp+basemap;
mix1mp = map2map(mix1mp,sanyoLCDGamInv/255);
mix2mp = redrange*redmp+greenrange*greenmp+bluerange*bluemp+basemap;
mix2mp = map2map(mix2mp,sanyoLCDGamInv/255);
allmps = [redhimp, cyanmidmp, cyanhimp, mix1mp, mix2mp];
%colormap(gray(256));
%imagesc(allmps);
%rgbplot(allmps(:,1:3));

%clear M;
%M = moviein(nt);
%figure(1);
%colormap(allmps(:,13:15));
%for i=1:nt
%  image(reshape(stim(:,i),nx,ny)+1), axis off
%  M(:,i) = getframe;
%end

%movie(M,5,10)

seq =  zerobitimage([nx ny],nt);
for i=1:nt
 InsertBitImage255(reshape(stim(:,i),nx,ny),seq,i);
end

bitimage = seq; m = nx; n = ny; nimages = nt; cmap = allmps*255;

save /home/engel/mac/color/expandingBlur bitimage m n nimages cmap


figure(1);
colormap(gray(256));
imagesc(reshape(window(:,1),nx,ny)+1);
figure(2);
colormap(gray(256));
imagesc(reshape(window(:,nt),nx,ny)+1);
