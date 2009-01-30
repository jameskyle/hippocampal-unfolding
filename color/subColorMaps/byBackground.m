%
%  Make a blue-yellow tiff file to serve as background for
%  the color tuning plots
%
nx = 128;
ny = 128;
x = 1:nx;
y = 1:ny;

lumWeight = (x - (nx/2)) ./ nx;
blueWeight = (y - (ny/2)) ./ ny;
[X Y] = meshgrid(lumWeight,blueWeight);
size(X)

nLevels = 128;
c = round( nLevels * ([1 1 0]'*X(:)' + [0 0 1]'*Y(:)'))/nLevels;
mmin(c), mmax(c)
half = [0.5; 0.5; 0.5];
c = c + half(:,ones(1,size(c,2)));
r = c(1,:); g = c(2,:); b = c(3,:);
% size(c)

% mp = gray(128);
% imagesc(reshape(b,nx,ny)),colormap(mp);

mpSize = 200;
[im, mp] = rgb2ind(r,g,b,mpSize);
% Brighten the map a bit
%
mp = 0.6* mp + 0.4;
im = reshape(im,ny,nx);
image(im), colormap(mp)
tiffwrite(im,mp,'byBackground.tiff')

% Now, scale up the size and smooth it using
% xv
%
unix('xv -perfect byBackground.tiff &')
