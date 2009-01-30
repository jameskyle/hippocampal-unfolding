function displayMovie(w,nx,ny,nt,skip,ps,sc)
%
%    function displayMovie(w,nx,ny,nt,skip,ps,sc)
%
%AUTHOR: Wandell
%PURPOSE: Temporary hack for checking whether things are going
%   well on stimulus generation.
%
%   w:  The matrix with movie images in the columns
%   nx,ny,nt:  the parameters of the movie images
%   skip:   frames to skip in presenting
%   ps:     pause parameter for display
%   sc:     if = 's' use imagesc instead of image
%

if nargin < 7
  sc = 'n';
end
if nargin < 6
 ps = 0.01;
end
if nargin < 5
 skip = 1;
end


axis image, axis off

if sc == 'n'
 for i = 1:skip:nt
  image(reshape(w(:,i),nx,ny))
  pause(ps)
 end
elseif sc == 's'
 for i = 1:skip:nt
  imagesc(reshape(w(:,i),nx,ny))
  pause(ps)
 end
end
