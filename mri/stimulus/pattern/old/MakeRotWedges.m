m=200;
n=200;

bitimage=RotatingWedges(m,n,8,24,3);

nimages=size(bitimage,2);

save '/home/engel/mac/wedgedat' bitimage m n nimages

