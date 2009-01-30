function G=gaussPyramid(im,filter,m);
% G=gaussPyramid(im,filter,m);
%     creates a Gaussian pyramid of m low pass images
%     by repeatedly filtering and down-sampling.
%     if m is not given, maximum size of pyramid is calculated
%     filter is a matrix used to contract the levels.
%
%     Pyramid format is a vector of concatenated pyramid level images.
%        First three enteries are reserved for number of levels in
%        pyramid and size of original image (rows,cols), respectively.
%        Order of pyramid level images is large to small (i.e. first
%        image in concatenated sequence is size(im))
%
%     see also:  constPyramid, laplacePyramid, allPyramids
%                getpyrSubim, putpyrSubim, getpyrSize
	         
if (nargin==2) 
	sz=getpyrSize(size(im),0);
	m=size(sz,1);
else
	sz=getpyrSize(size(im),m);
end

low=3;
G=zeros(1,sum(prod(sz'))+low);

G(1)=m;
G(2)=size(im,1);
G(3)=size(im,2);

for i=1:m
	G(low+1:low+prod(sz(i,:)))=im(:);
	low=low+prod(sz(i,:));
	if (i<m) 
		im=convolvecirc(im,filter,[2,2],[0,0]);
	end
end
