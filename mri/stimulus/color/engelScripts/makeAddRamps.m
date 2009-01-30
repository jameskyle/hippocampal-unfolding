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
linearmap = scale(gray(254),-1,1);   % 254 to leave first and last entries alone
redentry = [1 0 0; 0 0 0; 0 0 0 ];
greenentry = [0 0 0; 0 1 0; 0 0 0 ];
blueentry = [0 0 0; 0 0 0; 0 0 1 ];

greenramp1 = (mlevel+level1*linearmap) * greenentry;
blueramp1 = (mlevel+level1*linearmap) * blueentry;
redramp1 = (mlevel+level1*linearmap) * redentry;
greenramp2 = (mlevel+level2*linearmap) * greenentry;
blueramp2 = (mlevel+level2*linearmap) * blueentry;
redramp2 = (mlevel+level2*linearmap) * redentry;
greenramp3 = (mlevel+level3*linearmap) * greenentry;
blueramp3 = (mlevel+level3*linearmap) * blueentry;
redramp3 = (mlevel+level3*linearmap) * redentry;
greenramp4 = (mlevel+level4*linearmap) * greenentry;
blueramp4 = (mlevel+level4*linearmap) * blueentry;
redramp4 = (mlevel+level4*linearmap) * redentry;

redconst = mlevel*ones(254,3) * redentry;
greenconst = mlevel*ones(254,3) * greenentry;
blueconst = mlevel*ones(254,3) * blueentry;

map1 = redramp1+blueconst+greenconst;
map2 = redramp2+blueconst+greenconst;
map3 = redramp3+blueconst+greenconst;
map4 = redramp4+blueconst+greenconst;

allmps = [map1,map2,map3,map4];
for i = 1:(size(allmps,2)/3)
	mprange = [((i-1)*3+1):(i*3)];
	allmps(:,mprange) = map2map(allmps(:,mprange),sanyoLCDGamInv/255);
end
cmap = zeros(256,size(allmps,2));
cmap(2:255,:) = allmps;
cmap(256,:) = ones(1,size(allmps,2));
cmap = cmap*255;

save /home/engel/mac/color/redramp cmap

map1 = redconst+blueconst+greenramp1;
map2 = redconst+blueconst+greenramp2;
map3 = redconst+blueconst+greenramp3;
map4 = redconst+blueconst+greenramp4;

allmps = [map1,map2,map3,map4];
for i = 1:(size(allmps,2)/3)
	mprange = [((i-1)*3+1):(i*3)];
	allmps(:,mprange) = map2map(allmps(:,mprange),sanyoLCDGamInv/255);
end
cmap = zeros(256,size(allmps,2));
cmap(2:255,:) = allmps;
cmap(256,:) = ones(1,size(allmps,2));
cmap = cmap*255;

save /home/engel/mac/color/greenramp cmap

map1 = redramp1+blueconst+greenramp1;
map2 = redramp2+blueconst+greenramp2;
map3 = redramp3+blueconst+greenramp3;
map4 = redramp3+blueconst+greenramp4;

allmps = [map1,map2,map3,map4];
for i = 1:(size(allmps,2)/3)
	mprange = [((i-1)*3+1):(i*3)];
	allmps(:,mprange) = map2map(allmps(:,mprange),sanyoLCDGamInv/255);
end
cmap = zeros(256,size(allmps,2));
cmap(2:255,:) = allmps;
cmap(256,:) = ones(1,size(allmps,2));
cmap = cmap*255;

save /home/engel/mac/color/yellowramp cmap

map1 = redramp1+blueramp1+greenramp1;
map2 = redramp2+blueramp2+greenramp2;
map3 = redramp3+blueramp3+greenramp3;
map4 = redramp4+blueramp4+greenramp4;

allmps = [map1,map2,map3,map4];
for i = 1:(size(allmps,2)/3)
	mprange = [((i-1)*3+1):(i*3)];
	allmps(:,mprange) = map2map(allmps(:,mprange),sanyoLCDGamInv/255);
end
cmap = zeros(256,size(allmps,2));
cmap(2:255,:) = allmps;
cmap(256,:) = ones(1,size(allmps,2));
cmap = cmap*255;

save /home/engel/mac/color/grayramp cmap



