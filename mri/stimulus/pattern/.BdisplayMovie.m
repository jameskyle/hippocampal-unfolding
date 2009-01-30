function displayMovie(w,nx,ny,nt,skip)
%
for i = 1:skip:nt
 image(reshape(w(:,i),nx,ny)), axis image, axis off
 pause(0.1)
end
