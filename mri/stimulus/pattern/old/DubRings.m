function bitimage=ExpandingRings(m,n)
% Matlab code to generate expanding annuli stimulus
% Generates One full cycle of rings.

inner = pi/16;
nrings = 2;

d= ceil(m*(pi-inner)/(2*pi*nrings));
nimages=d*2;

[x,y]=meshgrid(linspace(-pi-inner,pi+inner,n),linspace(-pi-inner,pi+inner,m));
k=0.5;
r=sqrt(x.^2+y.^2)-inner;
ns=8;
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

   window = scale(sign(sin(r*nrings*2-2*pi*j/d)),1,2);
   for i=0:1
	img = (k)^i*checks .* window;  % img is -2, -1, 1, 2
	img = reshape(img,1,m*n);
	tmp = img;
	tmp(img == -2) = 254*ones(1,sum(img == -2));
	tmp(img == -1) = 253*ones(1,sum(img == -1));
	tmp(img == 1) = 2*ones(1,sum(img == 1));
	tmp(img == 2) = ones(1,sum(img == 2));
	img = reshape(tmp,m,n);
	img=getfix(img);
	InsertBitImage255(img,bitimage,imgnum);
	imgnum=imgnum+1
   end
end


%  window = scale(sign(sin(atan(y./x)*4+2*pi*j/nimages)));


