function G=constPyramid(imsize,m,val);
% G = constPyramid(imsize,m,val);
%	creates a pyramid structure with given entery values.
%
%	constPyramid(imsize,m,val) returns a pyramid structure
%	for an image of size imsize and m levels, with all enteries set
%	to val.
%
%	constPyramid(imsize,m) returns a blank (zeroed) pyramid 
%       structure for an image of size imsize and m levels.
%
%	constPyramid(imsize) returns a blank  (zeroed) pyramid structure
%	with the maximum number of levels.
%
%       Pyramid format is a vector of concatenated pyramid level images.
%        First three enteries are reserved for number of levels in
%        pyramid and size of original image (rows,cols), respectively.
%        Order of pyramid level images is large to small (i.e. first
%        image in concatenated sequence is size(im))
%
%       see also:  gaussPyramid, laplacePyramid, allPyramids
%                  getpyrSubim, putpyrSubim, getpyrSize

if (nargin==1) 
	sz=getpyrSize(imsize,0);
	m=size(sz,1);
        val = 0;
elseif (nargin==2)
	sz=getpyrSize(imsize,m);
        val = 0;
elseif (nargin==3)
	sz=getpyrSize(imsize,m);
end

low=3;
G = val .* ones(1,sum(prod(sz'))+low);

G(1)=m;
G(2:3)=imsize(:);

