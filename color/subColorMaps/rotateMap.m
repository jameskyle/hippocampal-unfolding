%
%  Make the color maps for polar and eccentricity plots
%  This is here as a script to show how the .tif files were
%  created

% function [wedge mp] = wedgeMap()

% Input arguments
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

% Pick out those locations that are within a radius 
% and that are on the right side of the axis (i.e., X>0)
%
radius = nX/2;
in = (dist < radius & X >= 0 );

% Set the angles of those locations that are NOT in the selected
% group to the value in the lookup table's last location
%
ang(~in) = nMap*ones(size(ang(~in)));

% colormap(gray(2)); imagesc(in) 
% imagesc(~in)
%

% Make an image
%
figure(1)
colormap(mp)
image(ang)
axis image, axis off

% tiffwrite(ang,mp,'rotateMap.tif');
% unix('xv rotateMap.tif &')
