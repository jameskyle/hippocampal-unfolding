cd /home/brian/exp/mri/stimuli

nx = 128;
ny = 128;
nt = 180;
pixperdeg = 128/20;
direction = 'r';
maxDistance = nx/2;
nspcyc = 2;
ntmcyc = 5;
tempcyclen = 30;
framespersec = nt/(tempcyclen);
spatialsup = 3*pixperdeg;
spatialsd = 1*pixperdeg;
temporalsup = 2*framespersec;
temporalsd = .25*framespersec;

spstep = (2*pi*nspcyc)/maxDistance;
splocs = [spstep:spstep:(2*pi*nspcyc)];     % Position of windowing function (pixels)
shiftStep = (length(splocs))/(nt*nspcyc);

spatialFilter = mkGaussKernel([spatialsup spatialsup],[spatialsd spatialsd]);
temporalFilter = mkGaussKernel( [1 temporalsup], [1 temporalsd]);
spwindowfun = scale(square(splocs),0,1);

window = makeCircularWindow(spwindowfun,nx,ny,nt,shiftStep,direction);
noise = makeFilteredNoise(nx,ny,nt, spatialFilter, temporalFilter);

wgt = 255;
noise = scale(noise,0,wgt);
stim = noise .* window;
for i = 1:nt
	img = reshape(stim(:,i),nx,ny);
	poo = getfix(img,0,255,0);
	stim(:,i) = reshape(poo,nx*ny,1);
end

load sanyoLCDGam	%Load the relevant gamma function

linearmap = gray(256);

	allmps(:,mprange) = map2map(allmps(:,mprange),sanyoLCDGamInv/255);

bitimage = seq; m = nx; n = ny; nimages = nt; cmap = allmps*255;

save /home/engel/mac/color/expandingBlur bitimage m n nimages cmap

