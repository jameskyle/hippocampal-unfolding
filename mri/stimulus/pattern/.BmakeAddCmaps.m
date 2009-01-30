%
%
%

cd /home/brian/exp/mri/stimuli

load sanyoLCDGam	%Load the relevant gamma function

mlevel = .5;
level1 = .05;
level2 = .1;
level3 = .2;
level4 = .4;
linearmap = scale(gray(254),-1,1);    % 254 to leave first and last entries alone
redentry = [1 0 0; 0 0 0; 0 0 0 ];
greenentry = [0 0 0; 0 1 0; 0 0 0 ];
blueentry = [0 0 0; 0 0 0; 0 0 1 ];
redramp = (mlevel+level3*linearmap) * redentry;
greenramp1 = (mlevel+level1*linearmap) * greenentry;
blueramp1 = (mlevel+level1*linearmap) * blueentry;
greenramp2 = (mlevel+level2*linearmap) * greenentry;
blueramp2 = (mlevel+level2*linearmap) * blueentry;
greenramp3 = (mlevel+level3*linearmap) * greenentry;
blueramp3 = (mlevel+level3*linearmap) * blueentry;
greenramp4 = (mlevel+level4*linearmap) * greenentry;
blueramp4 = (mlevel+level4*linearmap) * blueentry;
redconst = .5*ones(254,3) * redentry;
greenconst = .5*ones(254,3) * greenentry;
blueconst = .5*ones(254,3) * blueentry;

map1 = redramp+blueconst+greenconst;
map2 = redconst+blueramp1+greenramp1;
map3 = redconst+blueramp2+greenramp2;
map4 = redconst+blueramp3+greenramp3;
map5 = redconst+blueramp4+greenramp4;
map6 = redramp+blueramp2+greenramp2;
map7 = redramp+blueramp3+greenramp3;

allmps = [map1,map2,map3,map4,map5,map6,map7];
for i = 1:(size(allmps,2)/3)
	mprange = [((i-1)*3+1):(i*3)];
	allmps(:,mprange) = map2map(allmps(:,mprange),sanyoLCDGamInv/255);
end
cmap = zeros(256,size(allmps,2));
cmap(2:255,:) = allmps;
cmap(256,:) = ones(1,size(allmps,2));
cmap = cmap*255;

save /home/engel/mac/color/addMaps cmap
