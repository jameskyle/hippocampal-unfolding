function G = putpyrSubim(G,im);
%G = putpyrSubim(G,im);
%       inserts a subimage into pyramid.
%
%	putpyrSubim(G,im) inserts image im into pyramid G
%	image level is determined by the size of im.
%	
%       Pyramid format is a vector of concatenated pyramid level images.
%        First three enteries are reserved for number of levels in
%        pyramid and size of original image (rows,cols), respectively.
%        Order of pyramid level images is large to small (i.e. first
%        image in concatenated sequence is size(im))
%
%       see also:  getpyrSubim,  getpyrSize
%             constPyramid, gaussPyramid, laplacePyramid, allPyramids


sz=getpyrSize([G(2),G(3)],G(1));

n=find(size(im,1)==sz(:,1));
if (n & sz(n,2)==size(im,2))	
    low = 3;
    if (n==1)
        startpos = low+1;   
    else
        startpos = sum(prod(sz(1:n-1,:)'))+low+1 ;
    end;
    G(startpos:startpos+prod(sz(n,:))-1)=im(:);
else
    error('subimage size does not match any in pyramid.');
end

