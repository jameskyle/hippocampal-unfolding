function bitimage=ExpandingRings(m,n)
% Matlab code to generate Rotating Wedge stimulus
% Generates One full cycle of rings.

inner = pi/16;
nslices = 2;


d= ceil(m*(pi-inner)/(2*pi*nrings));
nimages=d*2;

[x,y]=meshgrid(linspace(-pi-inner,pi+inner,n),linspace(-pi-inner,pi+inner,m));
k=0.5;
r=sqrt(x.^2+y.^2)-inner;
ns=8;
nwedge=24;

out=find(r>pi | r<=0);
spot=find(r<-pi/20);

fix=getfix(m,n);


a=x(1,:);
k=-1; % flicker
bitimage=zerobitimage([m,n],nimages);
img=1;
for j=1:d

   checks=sign(sin(r*ns-pi*j*ns/(d*nrings)).*sin(nwedge*atan(y./x)/2));
   checks(out)=zeros(size(out));

   window = scale(sign(sin(r*nrings*2-2*pi*j/d)));
   for i=0:1
	image = scale((k)^i*checks .* window); 
	image(spot)=ones(size(image(spot)));	
	image(fix(:,1))=fix(:,2);

	InsertBitImage(image,bitimage,img);
	img=img+1
   end
   if(floor((j-1)/10)==(j-1)/10) 
	see(a,a,image);
   end
end


%  window = scale(sign(sin(atan(y./x)*4+2*pi*j/nimages)));


