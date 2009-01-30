m=200;
n=200;

bitimage=RotatingWedges(m,n,2);

nimages=size(bitimage,2);


save '/home/engel/mac/wedgedat' bitimage m n nimages

