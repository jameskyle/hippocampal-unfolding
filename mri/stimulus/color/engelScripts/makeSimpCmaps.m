%
%
%

cd /home/brian/exp/mri/stimuli

load sanyoLCDGam	%Load the relevant gamma function

mlevel = .5;
level1 = .5;
linearmap = scale(gray(254),-1,1);    % 254 to leave first and last entries alone
redentry = [1 0 0; 0 0 0; 0 0 0 ];
greenentry = [0 0 0; 0 1 0; 0 0 0 ];
blueentry = [0 0 0; 0 0 0; 0 0 1 ];
redramp = (mlevel+level1*linearmap) * redentry;
greenramp = (mlevel+level1*linearmap) * greenentry;
blueramp = (mlevel+level1*linearmap) * blueentry;
redconst = .5*ones(254,3) * redentry;
greenconst = .5*ones(254,3) * greenentry;
blueconst = .5*ones(254,3) * blueentry;

map1 = redramp+blueconst+greenconst;
map2 = redconst+blueconst+greenramp;
map3 = redramp+blueconst+greenramp;
map4 = redconst+blueramp+greenconst;
map5 = redramp+blueramp+greenramp;
map6 = redconst+blueramp+greenramp;
map7 = redramp+blueramp+greenconst;

allmps = [map1,map2,map3,map4,map5,map6,map7];
for i = 1:(size(allmps,2)/3)
	mprange = [((i-1)*3+1):(i*3)];
	allmps(:,mprange) = map2map(allmps(:,mprange),sanyoLCDGamInv/255);
end
cmap = zeros(256,size(allmps,2));
cmap(2:255,:) = allmps;
cmap(256,:) = ones(1,size(allmps,2));
cmap = cmap*255;

save /home/engel/mac/color/simpMaps cmap



