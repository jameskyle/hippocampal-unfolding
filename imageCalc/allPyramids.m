function G=allPyramids(im,filter,m);
% [G,L]=allPyramids(im,filter,m);
%     creates a Gaussian and a Laplacian pyramid of m images.
%     if m is not given, maximum size of pyramid is calculated
%     filter is a matrix used to expand and contract the levels.
%
%     Pyramid format is a vector of concatenated pyramid level images.
%        First three enteries are reserved for number of levels in
%        pyramid and size of original image (rows,cols), respectively.
%        Order of pyramid level images is large to small (i.e. first
%        image in concatenated sequence is size(im))
%
%     see also: constPyramid, gaussPyramid, laplacePyramid, reconPyramid
%               getpyrSubim, putpyrSubim, getpyrSize

if (nargin==2) 
	sz=getpyrSize(size(im),0);
	m=size(sz,1);
else
	sz=getpyrSize(size(im),m);
end

low=3;
G=zeros(1,sum(prod(sz'))+low);
L=zeros(1,sum(prod(sz'))+low);

G(1)=m;
G(2)=size(im,1);
G(3)=size(im,2);

L(1)=m;
L(2)=size(im,1);
L(3)=size(im,2);

G(low+1:low+prod(sz(1,:)))=im(:);
gim=im;
for i=1:m-1
        G(low+1:low+prod(sz(i,:)))=gim(:);
	ngim=convolvecirc(gim,filter,[2,2]);
	im=gim-4*expandcirc(ngim,filter,[2,2],[0,0],sz(i,:));
	L(low+1:low+prod(sz(i,:)))=im(:);
	low=low+prod(sz(i,:));
        gim=ngim;
end

% tack on low pass at end
sz(m,:)=size(gim);
G(low+1:low+prod(sz(m,:)))=gim(:);
L(low+1:low+prod(sz(m,:)))=gim(:);

