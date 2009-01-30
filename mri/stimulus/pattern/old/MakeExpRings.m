m=200;
n=200;

bitimage=ExpandingRings(m,n,2);

nimages=size(bitimage,2);


save '/home/engel/mac/ringdat' bitimage m n nimages

