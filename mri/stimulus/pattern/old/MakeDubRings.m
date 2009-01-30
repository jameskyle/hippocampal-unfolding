clear;
m=128;
n=128;

bitimage=DubRings(m,n);
nimages=size(bitimage,2);

contrasts = [0,.0316,.0750,.1778,.4217,1.0]/2;
refmin = .5+contrasts(4);
refmax = .5-contrasts(4);
linearmap = gray(252);	% To save first and last entries
allmps = zeros(252,18);
for i = 1:(size(allmps,2)/3)
	mprange = [((i-1)*3+1):(i*3)];
	minc = .5-contrasts(i);
	maxc = .5+contrasts(i);
	allmps(:,mprange) = scale(linearmap,minc,maxc);
end
cmap = zeros(256,size(allmps,2));
cmap(3:254,:) = allmps;
cmap(256,:) = ones(1,size(allmps,2));
cmap(2,:) = refmin*ones(1,size(allmps,2));
cmap(255,:) = refmax*ones(1,size(allmps,2));
cmap = cmap*255;

save /home/engel/mac/color/doubring bitimage m n nimages cmap

cmap([2,255],:) = .5*255*ones(2,size(cmap,2));

save /home/engel/mac/color/doubringgraymap cmap
