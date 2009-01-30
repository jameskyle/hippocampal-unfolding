%
%  Make the color maps for polar and eccentricity plots
%
%
cd /wusr5/brian/papers/mri/color/fig/talks/subColorMaps

[X Y] = meshgrid(1:128,1:128);
X = X - 64; Y = Y - 64;
load wedgemap
mp = nump;

%  Wedge map
%
ang = atan(Y ./ (X + eps));
ang = scale(ang,1,128);
dist = sqrt(X.^2 + Y.^2);
in = (dist < 64 & X >= 0 );
ang(~in) = 129*ones(size(ang(~in)));

figure(1)
wedge = ang(:,65:128);
colormap(mp)
image(wedge)
axis image, axis off
tiffwrite(wedge,mp,'wedgeMap.tif');
unix('xv wedgeMap.tif &')

% Expanding map
%
ang = atan(Y ./ (X + eps));
ang = scale(ang,1,128);
dist = sqrt(X.^2 + Y.^2);
in = (dist < 64 & X >= 0 );

figure(1)
ecc = 2*dist(:,65:128);
dist(~in) = 129*ones(size(dist(~in)));
colormap(mp)
image(ecc)
axis image, axis off
tiffwrite(ecc,mp,'eccMap.tif');
unix('xv eccMap.tif &')
