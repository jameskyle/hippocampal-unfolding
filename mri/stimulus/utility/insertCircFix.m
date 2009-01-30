function img = insertCircFix(img,fixcolor,fixdiam)

% Function to insert a circular fixation mark (spot)
%  HB, 1/31/96
%
%  img = insertCircFix(img,fixcolor,fixdiam)
%
%  img:  Original image which will be replaced
%  fixcolor:  Color table value for fixation spot
%  fixdiam:  Diameter of fixation spot (in pixels)

% Debugging:
%img = 128*(ones(480,640));
%fixdiam = 20;
%fixcolor = 3;
%cmp = gray(256);
%cmp(3,:) = [1 0 0];
%

nx = size(img,2);
ny = size(img,1);
fixrad = fixdiam/2;

x = ((-nx/2)+1):(nx/2);
y = ((-ny/2)+1):(ny/2);
[X,Y] = meshgrid(x,y);
R = sqrt(X .^2 + Y .^2) +eps;

circf = fixcolor * (R <= fixrad);

tmp = R > fixrad;
tmp2 = img .* tmp;

img = tmp2 + circf;

return

figure(1)
clf
image(img)
axis image
axis off
colormap(cmp)





