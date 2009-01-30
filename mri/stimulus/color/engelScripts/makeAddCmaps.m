%
%
%

load sanyoLCDGam	%Load the relevant gamma function

%  Background level
%
mlevel = .5;

%  Stimulus contrast levels
%
levels = [.04 .08 .16 .32 .5];

%  
contramp = scale(gray(254),-1,1);    % 254 to leave first and last entries alone
redentry = [1 0 0; 0 0 0; 0 0 0 ];
greenentry = [0 0 0; 0 1 0; 0 0 0 ];
blueentry = [0 0 0; 0 0 0; 0 0 1 ];

redmaps = zeros(254,length(levels)*3);
for i = 1:length(levels)
  % 3 columns for ith cmap in allmps 
  mprange = [((i-1)*3+1):(i*3)]; 	
  redmaps(:,mprange) = ((levels(i)*contramp) * redentry) +mlevel;
end

greenmaps = zeros(254,length(levels)*3);
for i = 1:length(levels)
  % 3 columns for ith cmap in allmps 
  mprange = [((i-1)*3+1):(i*3)]; 	
  greenmaps(:,mprange) = ((levels(i)*contramp) * greenentry) +mlevel;
end

yellowmaps = zeros(254,length(levels)*3);
for i = 1:length(levels)
  % 3 columns for ith cmap in allmps 
  mprange = [((i-1)*3+1):(i*3)];	
  yellowmaps(:,mprange) = ...
      ((levels(i)*contramp) * (redentry+greenentry)) +mlevel;
end

allmps = [redmaps greenmaps yellowmaps];
for i = 1:(size(allmps,2)/3)
  mprange = [((i-1)*3+1):(i*3)];
  allmps(:,mprange) = map2map(allmps(:,mprange),sanyoLCDGamInv/255);
end

cmap = zeros(256,size(allmps,2));
cmap(2:255,:) = allmps;
cmap(256,:) = ones(1,size(allmps,2));
cmap = cmap*255;

save /home/engel/mac/color/addMaps cmap



