function filteredNoise = ...
	makeFilteredNoise(nx,ny,nt,spatialFilter,temporalFilter,seed) 
%
%  filteredNoise = 
%	makeFilteredNoise(nx,ny,nt,spatialFilter,temporalFilter,seed)
% 
% AUTHOR:  Engel, Wandell
%  
% DATE:    02.17.95
% PURPOSE:
%	Create a filtered space-time noise movie.
%
%  nx,ny,nt:  The spatial dimensions (nx,ny) and the number of 
%  temporal samples (nt)
%  spatialFilter:  2d spatial filter to apply to white noise
%  temporalFilter:  1d temporal filter to apply to white noise
%  seed:  If you want to control the white noise for replicability,
%	then send in a seed value
%

disp('Newest Version!');
if nargin == 6
  randn(seed)
end

whiteNoise = zeros(nx*ny,nt);
filteredNoise = zeros(nx*ny,nt);
for i=1:nt
   disp(['Generating Randoms ',num2str(i)]);	
   whiteNoise(:,i) = randn(nx*ny,1);
   foo = whiteNoise(:,i) < -2;
   whiteNoise(foo,i) = -2*ones(sum(foo),1);
   foo = whiteNoise(:,i) > 2;
   whiteNoise(foo,i) = 2*ones(sum(foo),1);
end

if(nargin > 3)
if(spatialFilter ~= [])
for i=1:nt
  disp(['Spatial Convolution ',num2str(i)]);	
  f = reshape(whiteNoise(:,i),nx,ny);
%  f = convolvecirc(f,spatialFilter);
  f = cirConv2(f,spatialFilter);
  filteredNoise(:,i) = reshape(f,nx*ny,1);
end
end

if(temporalFilter ~= [])
for i=1:nx*ny
  f = reshape(filteredNoise(i,:),1,nt);
  f = convolvecirc(f,temporalFilter);  
  filteredNoise(i,:) = reshape(f,1,nt);
end
end
end
