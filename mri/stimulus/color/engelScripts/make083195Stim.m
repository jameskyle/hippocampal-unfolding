%
%
%
cd /home/brian/exp/mri/stimuli/calibration

load sanyoLCDGam	% Load the relevant gamma function
load /usr/local/matlab/toolbox/stanford/color/data/sanyoLCD/082895/sanyoLCD82895 % spd
load ncones

rgb2lms = (ncones')*sanyoLCD; 	%  3x3 conversion matrix

lms2rgb = inv(rgb2lms);		%  Columns contain cone-isolating lights 
maxlstim = lms2rgb(:,1)/max(abs(lms2rgb(:,1)));   % These are in rgb contrasts
maxmstim = lms2rgb(:,2)/max(abs(lms2rgb(:,2)));
maxsstim = lms2rgb(:,3)/max(abs(lms2rgb(:,3)));

lmixes = [0 .5 1 -.5 .75 .25];
mmixes = [1 .5 0 .5 .25 .75];
nummixes = length(lmixes);
stims = zeros(3,nummixes);
for i = 1:nummixes
	stims(:,i) =  lmixes(i)*maxlstim+mmixes(i)*maxmstim;
	stims(:,i) = stims(:,i)/max(abs(stims(:,i)));
end

mlevel = .5;
levels = [.125 .25 .5];
contramp = scale(gray(254),-1,1);   % 254 to leave first and last for w/b
allmps = zeros(254,nummixes*length(levels)*3);
strt = 1;
for i = 1:nummixes
   for j = 1:length(levels)
	mprange = [strt:strt+2];	% 3 columns for ith cmap in allmps 
	allmps(:,mprange) = ((levels(j)*contramp) * diag(stims(:,i))) ...
					 + mlevel;
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

%save /home/engel/mac/color/cmap083195 cmap

backrgb = [.5 .5 .5]';
backlms = rgb2lms*backrgb;			

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
