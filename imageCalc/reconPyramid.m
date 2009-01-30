function im=reconPyramid(G,filter);
%  im=reconPyramid(G,filter);
%	reconstruct an image from its laplacian pyramid.
%
%	reconPyramid(G,filter) returns image from pyramid G
%	using 'filter'.
%	
%       Pyramid format is a vector of concatenated pyramid level images.
%        First three enteries are reserved for number of levels in
%        pyramid and size of original image (rows,cols), respectively.
%        Order of pyramid level images is large to small (i.e. first
%        image in concatenated sequence is size(im))
%
%       see also:  laplacePyramid, constPyramid, gaussPyramid, allPyramids
%                  getpyrSubim, putpyrSubim, getpyrSize


m=G(1);
sz=getpyrSize([G(2),G(3)],G(1));
im=getpyrSubim(G,m); % final low-pass image
for i=m-1:-1:1
        im=4*expandcirc(im,filter,[2,2],[0,0],sz(i,:))+getpyrSubim(G,i);
end
