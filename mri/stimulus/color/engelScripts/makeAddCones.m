%PURPOSE:
%  
%INPUT ARGUMENTS:
%  Monitor primary SPDs
%  Monitor gamma data file, containing the invGamma function
%
%  Single (L,M,S) coordinates of background
%  lmsStimuli:  Cone contrast values of the stimulus in the columns
%
%RETURNS
%  A matrix whose triplets of columns are color maps.
%  The color maps are 256 x 3.  
%  In these experiments the images only have two levels (and then
%  there is the background) so we only really vary two color map
%  entries as we go from map to map.
%
%
load sanyoLCDGam	% Load the relevant gamma function
load sanyoLCD		% Relevant spd
load ncones

lmsDirection = eye(3,3);
% lmsBackground = rgb2lms*[.5 .5 .5]'
lmsBackground = [    0.0452    0.0418    0.0186]';

lmsContrast = [1 0 0]'
lmsContrast = [-1 0 0]'

lms2rgb * (lmsContrast.*lmsBackground + lmsBackground)



%  3x3 conversion matrix between LMS and RGB space
% for this display
%
rgb2lms = (ncones')*sanyoLCD; 	
lms2rgb = inv(rgb2lms);		

rgbDirection = lms2rgb*lmsDirection;
rgbBackground = lms2rgb*lmsBackground;
rgbTotal =  ...
    rgbBackground(:,ones(1,size(rgbDirection,2))) + rgbDirection

% Set these values so that the largest entry is +/- 1
%  
maxlstim = lms2rgb(:,1)/max(abs(lms2rgb(:,1)))
maxmstim = lms2rgb(:,2)/max(abs(lms2rgb(:,2)))
maxsstim = lms2rgb(:,3)/max(abs(lms2rgb(:,3)))

mixes = [0 .2 .4 .5 .6 .8 1];
nmixes = length(mixes);
stims = zeros(3,nmixes);
for i = 1:nmixes
  stims(:,i) =  mixes(i)*maxlstim + (1-mixes(i))*maxmstim;
  stims(:,i) = stims(:,i)/max(abs(stims(:,i)));
end

mlevel = .5;
levels = [.125 .25 .5];

% 254 levels rather than 256 because first and last
% are reserved for white and black in the Mac run program
%
contramp = scale(gray(254),-1,1);   

%  Make space to save all of the color maps
% 
allmps = zeros(254,nmixes*length(levels)*3);

% Cumulate all of the color maps at different contrast levels.
strt = 1;
for i = 1:nmixes
  for j = 1:length(levels)
    % 3 columns for ith cmap in allmps 
    mprange = [strt:strt+2]; 		
    allmps(:,mprange) = ((levels(j)*contramp) * diag(stims(:,i))) ...
	+ mlevel;
    strt = strt+3;
  end
end

% Modern equivalent of the stuff below
%
% foo = rgb2dac(allmps(:,7:9), sanyoLCDGamInv);
% plot(foo)

% Gamma correct maps
for i = 1:(size(allmps,2)/3)
  mprange = [((i-1)*3+1):(i*3)];
  allmps(:,mprange) = map2map(allmps(:,mprange),sanyoLCDGamInv/255);
end
figure(2);plot(allmps(:,7:9))


% 
cmap = zeros(256,size(allmps,2));
cmap(2:255,:) = allmps;
cmap(256,:) = ones(1,size(allmps,2));
cmap = cmap*255;

save /home/engel/mac/color/coneramps cmap

