%
%
%
cd /home/brian/exp/mri/stimuli/calibration

load sanyoLCDGam	% Load the relevant gamma function
load sanyoLCD		% Relevant spd
load /home/brian/matlab/cap/ncones

rgb2lms = (ncones')*sanyoLCD; 	%  3x3 conversion matrix

backrgb = [.5 .5 .5]';
backlms = rgb2lms*backrgb;			

lms2rgb = inv(rgb2lms);		%  Columns contain cone-isolating lights 
ballstim = lms2rgb*[backlms(1),0,0]';		% Full cone contrast l stim
balmstim = lms2rgb*[0,backlms(2),0]';		% Full cone contrast m stim
balsstim = lms2rgb*[0,0,backlms(3)]';		% Full cone contrast s stim

ymixes = [0 .5 1 -.5 .75 .25];			% Generate mixture directions
smixes = [1 .5 0 .5 .25 .75];
nummixes = length(ymixes);
stims = zeros(3,nummixes);
for i = 1:nummixes
	stims(:,i) = smixes(i)*balsstim+ymixes(i)*(ballstim+balmstim);
	stims(:,i) = stims(:,i)/max(abs(stims(:,i))); % Normed to 1 for 1 gun
end

levels = [.25 .5 1.0];
contramp = scale(gray(254),-1,1);   % 254 for room for w/b
meanmap = ones(254,3)*diag(backrgb);
allmps = zeros(254,nummixes*length(levels)*3);
strt = 1;
for i = 1:nummixes
   coldir = stims(:,i);			% Color direction
   maxgun = find(abs(coldir) == max(abs(coldir)));  % Which gun is maxed out
   coldir = coldir*backrgb(maxgun);	% Scale to be contrast of 1
   for j = 1:length(levels)
	mprange = [strt:strt+2];	% 3 columns for ith cmap in allmps 
	allmps(:,mprange) = ((levels(j)*contramp) * diag(coldir)) ...
					+ meanmap;
	strt = strt+3;
   end
end

% Gamma correct maps
for i = 1:(size(allmps,2)/3)
	mprange = [((i-1)*3+1):(i*3)];
	newmps(:,mprange) = map2map(allmps(:,mprange),sanyoLCDGamInv/255);
end
cmap = zeros(256,size(newmps,2));
cmap(2:255,:) = newmps;
cmap(256,:) = ones(1,size(newmps,2));
cmap = round(cmap*255);

save /home/engel/mac/color/cmap090995 cmap

for i = 1:nummixes
	whichmp = i*3;
	whichinds = ((whichmp-1)*3+1):(whichmp*3);
	foo = cmap(255,whichinds);
	tmp = allmps(254,whichinds);
	goo = ((rgb2lms*tmp')-backlms)./backlms;
	[foo goo']
end






