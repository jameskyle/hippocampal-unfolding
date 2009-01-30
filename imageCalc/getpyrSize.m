function sz=getpyrSize(imsize,m);
% getpyrSize - 	gets subimage sizes of pyramid
%
%	getpyrSize(imsize,m) returns an mx2 matrix of pyramid image sizes
%
%       getpyrSize(imsize,0) or getpyrSize(imsize) returns an mx2 matrix where 
%	m is the maximum number of subimages (i.e min(log2(imsize))+1 )
%
%	see also:  getpyrSubim, putpyrSubim, 
%	           gaussPyramid,laplacePyramid, allPyramids
 
if (nargin ==1 ) 
        m=0;
end

sz(1,:)=imsize;

i=1;
while (i~=m & min(sz(i,:)>1))
	sz(i+1,:)=ceil(sz(i,:)/2);
	i=i+1;
end;

