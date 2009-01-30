function subim = getpyrSubim(G,n);
% subim = getpyrSubim(G,n);
%	retrieves subimage from image pyramid.
%
%	getpyrSubim(G,n) returns subimage at level n from pyramid G
%	
%       Pyramid format is a vector of concatenated pyramid level images.
%        First three enteries are reserved for number of levels in
%        pyramid and size of original image (rows,cols), respectively.
%        Order of pyramid level images is large to small (i.e. first
%        image in concatenated sequence is size(im))
%
%       see also:  putpyrSubim,  getpyrSize
%             constPyramid, gaussPyramid, laplacePyramid, allPyramids

sz=getpyrSize([G(2),G(3)],G(1));
low = 3;
if (n==1)
    startpos = low+1;   
else
    startpos = sum(prod(sz(1:n-1,:)'))+low+1 ;
end;
subim = reshape(G(startpos:startpos+prod(sz(n,:))-1),sz(n,1),sz(n,2));

