function displayMovie(w,nx,ny,nt,skip,ps)
%
if nargin < 6
 ps = 0.01;
end
if nargin < 5
 skip = 1;
end

for i = 1:skip:nt
 image(reshape(w(:,i),nx,ny)), axis image, axis off
 pause(ps)
end
