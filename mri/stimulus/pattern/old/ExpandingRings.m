function bitimage=ExpandingRings(m,n,nrings)
% Matlab code to generate expanding annuli stimulus
% Generates One full cycle of rings.

inner = pi/16;

d= ceil(m*(pi-inner)/(2*pi*nrings));
nimages=d*2;

[x,y]=meshgrid(linspace(-pi-inner,pi+inner,n),linspace(-pi-inner,pi+inner,m));
r=sqrt(x.^2+y.^2)-inner;
ns=6*nrings;
nwedge=24;

out=find(r>pi | r<=0);
spot=find(r<-pi/20);

a=x(1,:);
k=-1; % flicker
bitimage=zerobitimage([m,n],nimages);
imgnum=1;
for j=1:d

   checks=sign(sin(r*ns-pi*j*ns/(d*nrings)).*sin(nwedge*atan(y./x)/2));
   checks(out)=zeros(size(out));

   window = scale(sign(sin(r*nrings*2-2*pi*j/d)),0,1);
   for i=0:1
	img = scale((k)^i*checks .* window,1,254); 
	img=getfix(img);
	InsertBitImage255(img,bitimage,imgnum);
	imgnum=imgnum+1
   end
end




