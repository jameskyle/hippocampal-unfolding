% function [im mp] = expandMap([nX nY], mp, radius) 
%
%  Make the color maps for polar and eccentricity plots
%  Functionalize this when we can.
%
%
% See also:  cmapRotate, e.g. 
%  foo = cmapRotate(wedgemap(1:128,:),-32);
%  foo = [foo; 0.5 0.5 0.5];
%
%


nX = 128;
nY = 128;
load cmap
nMap = size(mp,1);

% Create a grid of (X,Y) values
%
[X Y] = meshgrid(1:nX,1:nY);

% Center the grid around (0,0)
%
X = X - (nX/2); Y = Y - (nY/2);

%  Find the angle for each of the X,Y points
%
ang = atan(Y ./ (X + eps));
ang = scale(ang,1,(nMap - 1));
dist = sqrt(X.^2 + Y.^2);

radius = nX/2;
in = (dist < radius & X >= 0 );

%
%
figure(1)
dist(~in) = nMap*ones(size(dist(~in)));
dist(in) = 2*dist(in);
colormap(mp)
image(dist)
axis image, axis off

% tiffwrite(dist,mp,'expandMap.tif');
% unix('xv expandMap.tif &')
