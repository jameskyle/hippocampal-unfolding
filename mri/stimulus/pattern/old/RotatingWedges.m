function bitimage=ExpandingRings(m,n,nrings,nwedge,npanes)
% Matlab code to generate Rotating Wedge stimulus
% Generates One full cycle of wedges

inner = pi/16;


[x,y]=meshgrid(linspace(-pi-inner,pi+inner,n),linspace(-pi-inner,pi+inner,m));
r=sqrt(x.^2+y.^2)-inner;
ns=nrings;

theta = pi+atan2(y,x);
d = 50;
nimages = d*2;

out=find(r>pi | r<=0);

k=-1; % flicker
bitimage=zerobitimage([m,n],nimages);
imgnum=1;

for j=1:d

   checks=sign(sin(r*ns).*sin(nwedge*theta-2*pi*j*nwedge/(d*npanes)));
   checks(out)=zeros(size(out));
   window = scale(sign(sin(npanes*theta-2*pi*j/d)),0,1);
   for i=0:1
	img = scale((k)^i*checks .* window,1,254); 
	img=getfix(img);
	InsertBitImage255(img,bitimage,imgnum);
	imgnum=imgnum+1
   end
%   figure(1)
%   colormap(gray(255));
%   image(reshape(img,m,n))
%   ginput(1);

end


