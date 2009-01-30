%
%
%
cd /home/brian/exp/mri/stimuli/calibration

load sanyoLCDGam	% Load the relevant gamma function
load sanyoLCD		% Relevant spd
load ncones

rgb2lms = (ncones')*sanyoLCD; 	%  3x3 conversion matrix
lms2rgb = inv(rgb2lms);		%  Columns contain cone-isolating lights 

backrgb = [.5 .5 .5]';
backlms = rgb2lms*backrgb;			

ballrgb = lms2rgb*[backlms(1),0,0]';	% Full cone contrast l stim
balmrgb = lms2rgb*[0,backlms(2),0]';	% Full cone contrast m stim
balsrgb = lms2rgb*[0,0,backlms(3)]';	% Full cone contrast s stim

lmixes = [0 1 1 -1 1 1/2];		% Generate mixture directions
mmixes = [0 1 1 -1 1 1/2];
smixes = [1 0 1 1 1/2 1] ;


nummixes = length(lmixes);
rgbstims = zeros(3,nummixes);

	% Problem = cant go full cone contrast if background is not exactly 
	%		the monitor's mean, will get values out of range.

for i = 1:nummixes
	lmsdir = lmixes(i)*[1 0 0]'+mmixes(i)*[0 1 0]'+smixes(i)*[0 0 1]';
	rgbdir = lmsdir(1)*ballrgb+lmsdir(2)*balmrgb+lmsdir(3)*balsrgb;

	tmp = abs(rgbdir)./backrgb;	%Check for over top of range
	[mx,ix] = max(tmp);
	if(mx > 1)
		rgbdir = rgbdir ./ tmp(ix);
	end
	tmp = abs(rgbdir)./(1-backrgb); %Check if below bottom of range
	[mx,ix] = max(tmp);
	if(mx > 1)
		rgbdir = rgbdir ./ tmp(ix);
	end
	rgbstims(:,i) = rgbdir;		
end

levels = [.25 .5 1];
	
contramp = scale(gray(254),-1,1);   % 254 for room for w/b
meanmap = ones(254,3)*diag(backrgb);
allmps = zeros(254,nummixes*length(levels)*3);
strt = 1;
for i = 1:nummixes
   coldir = rgbstims(:,i);	   % Color direction
   for j = 1:length(levels)
	mprange = [strt:strt+2];   % 3 columns for ith cmap in allmps 
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

%save /home/engel/mac/color/cmap032696 cmap
	
disp('Back rgb = ');
disp(cmap(128,1:3));
for i = 1:nummixes
	whichmp = i*length(levels);
	whichinds = ((whichmp-1)*3+1):(whichmp*3);
	foo = abs(cmap(255,whichinds)-cmap(128,whichinds));
	tmp = allmps(254,whichinds);
	goo = ((rgb2lms*tmp')-backlms)./backlms;
	disp(['stim',num2str(i),' deltar deltag deltab l m s contr']);
	disp([foo goo' sqrt(goo'*goo)]);
end





