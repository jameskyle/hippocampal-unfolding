%
%	make Blue Cone stimulus
%
cd /home/brian/exp/mri/stimuli

nx = 32;
ny = 32;
nt = 32;

uniformNoise = zeros(nx*ny,nt);
blueNoise = zeros(nx*ny,nt);

for i=1:nt
   uniformNoise(:,i) = rand(nx*ny,1);
end

%colormap(gray(64))
%for i=1:nt
%  imagesc(reshape(uniformNoise(:,i),nx,ny))
%  pause(0.5)
%end

spatialFilter = mkGaussKernel([.25*nx .25*ny],[.05*nx 0.05*ny]);
colormap(ones(3,3))
mesh(spatialFilter)

temporalFilter = mkGaussKernel( [1 0.25*nt], [1 0.1*nt])
plot(temporalFilter)

for i=1:nt
  f = reshape(uniformNoise(:,i),nx,ny);
  f = CirConv2(f,spatialFilter);
  blueNoise(:,i) = reshape(f,nx*ny,1);
end

for i=1:nx*ny
  f = reshape(blueNoise(i,:),1,nt);
  f = CirConv(f,temporalFilter);  
  blueNoise(i,:) = reshape(f,1,nt);
end

colormap(gray(64))
for i=1:nt
  imagesc(reshape(blueNoise(:,i),nx,ny))
  pause(0.5)
end

redNoise = uniformNoise - blueNoise;
colormap(gray(64))
for i=1:nt
  imagesc(reshape(redNoise(:,i),nx,ny))
  pause(0.5)
end

%%%%%%%%%%%%%%%%%%%
%
%		Make the moving Gaussian annular window
%
%
%	Make the distances from the center so we can
%	move the Gaussian annulus along properly
%
%	The Gaussian Annulus peak is at nx
%
gaussianAnnulus = mkGaussKernel([1 nx],[ 1 0.1*nx]);

xdistances = ones(ny,1)*[1:nx];
ydistances = (xdistances');
xdistances = xdistances - (nx/2);
ydistances = ydistances - (ny/2);
distances = sqrt(xdistances.^2 + ydistances.^2);

window = zeros(size(uniformNoise));

for i=1:nx
 f = mod(round(distances - i) + (nx/2),nx-1) + 1;
 window(:,i) = reshape(gaussianAnnulus(f),nx*ny,1);
end

colormap(gray(64))
for i=1:nt
  imagesc(reshape(window(:,i),nx,ny))
  pause(0.5)
end

blueNoiseAnnulus = window .* blueNoise;
redNoiseAnnulus =  window .* redNoise;

colormap(gray(64))
for i=1:nt
  imagesc(reshape(blueNoiseAnnulus(:,i),nx,ny))
  pause(0.5)
end

colormap(gray(64))
for i=1:nt
  imagesc(reshape(redNoiseAnnulus(:,i),nx,ny))
  pause(0.5)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	To combine the two we need to, image by image,
%
%	1.  Convert the relevant two indexed images to 24 bit rgb,
%	2.  Add the rgb images
%	3.  Convert back to indexed images
%
%
%	Adding them in shifted phase

sh = nt/2;
r = (0:63)'/64;
z = zeros(64,1);
bMap = [z z r];
yMap = [r r z];
size(bMap)

for i=0:nt-1
 bn = blueNoiseAnnulus(:,i+1);		% Only the blue gun
 rn = redNoiseAnnulus(:,mod(i+sh,nt) + 1); % Only the red and green guns

image(reshape(currentIm,nx,ny)), colormap(currentMap)
imagesc(reshape(bn,nx,ny)), colormap(bMap)
imagesc(reshape(rn,nx,ny)), colormap(yMap)


 z = zeros(size(rn));
 [bn1 bn2 bn3] = ind2rgb(64*bn,bMap);
 [rn1 rn2 rn3] = ind2rgb(64*rn,yMap);
 sn1 = (rn1+bn1)/2;
 sn2 = (rn2+bn2)/2;
 sn3 = (rn3+bn3)/2;

 [currentIm currentMap] = rgb2ind(sn1,sn2,sn3);

 plot(currentMap)

 imagesc(reshape(currentIm,nx,ny)),colormap(currentMap)
