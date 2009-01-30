% unfoldDist.m
% ------------
%
% version 2.0
%
% function [mDist, dSampNeighbors, xSampNeighbors, ...
%          xSampGray] = unfoldDist(grayNodes, grayEdges,  ...
%          sampSpacing, dimdist);
%
%  AUTHOR: Brian Wandell, Patrick Teo
%    DATE: Autumn 1995
% PURPOSE:
%       It checks the continuity of the gray volume, sub-samples the volume 
%       and  creates several of the distance matrices and other variables 
%       that are needed to perform the flattening step. The key 
%       matrices and variables that are returned (and also saved) are:
%                  mDist : Matrix of distances along the manifold between 
%                          sample points (measured within the cortex). 
%                          (Size: nSamp x nSamp  -- can be big)
%         dSampNeighbors : Distances between sample points and 'nNeighbors'
%                          neighboring sample points.  
%                          (Size: nSamp x nNeighbors [see below])
%         xSampNeighbors : Matrix of gray matter indices to the same points
%                          as in 'dSampNeighbors' matrix, that are neighbors 
%                          of the sample points. 
%                          (Size: nSamp x nNeighbors)
%              xSampGray : The index function from the sample points 
%                          to the gray matter points.
%                          (Size: 1 x nSamp)
%
%
% ARGUMENTS: 
%   grayNodes : 
%   grayEdges :
%   sampSpacing : The sub-sampling spacing in the x,y and z directions.
%   dimdist : Size of each voxel in millimeters. (Used in the
%     'mrManifoldDistance' function that measures the 
%     distances along the manifold.
%
%         

function [mDist,dSampNeighbors,xSampNeighbors,xSampGray] = ... 
    unfoldDist(grayNodes,grayEdges,sampSpacing,dimdist);

% Call smpCrds to pick the sample locations
% 

 nGray = size(grayNodes,2);
 [xSampGray] = smpCrds(grayNodes, grayEdges, sampSpacing, dimdist);

 nSamp = length(xSampGray);
 
%% Make the distance matrix between the sample points, 'mDist';
%
 fprintf('\nConstructing matrix mDist\n');

 mDist = zeros(nSamp,nSamp);  % Initialize 'mDist'.
 vDist = zeros(1,nGray);      % Initialize temporary distance vector.

 for i=1:nSamp
   tic;
   startPt = xSampGray(i);
  
   % Get the distances to all other points from 'startPt'.
   vDist = mrManDist(grayNodes, grayEdges, startPt, dimdist);

   % Save in 'mDist' matrix.
   mDist(i,:) = vDist(xSampGray);
   t = toc;

   % Print out how much longer!
   if rem(i,25) == 0
     s = sprintf('%d pts left. Estimated remaining minutes: %.1f ', ...
                  nSamp-i,t/60*(nSamp-i));
     disp(s)
   end
 end


%% Calculate the two matrices defining the gray matter (volume data)
%% index to the neighbors of each sample point, 'xSampNeighbor';
%% and the distances from the sample points to each of these
%% gray matter points, dSampNeighbor.
%% Draw a sphere around each gray matter point that should include at 
%% least three different sample points.
%% Each gray point should be represented about 5-10 times.
%
 fprintf('\n\nConstructing matrices xSampNeighbors and dSampNeighbors\n');

 % Calculate the radius that is drawn around each gray matter point.
 if length(sampSpacing) == 3
   m = 3*max(sampSpacing);
   nRadius = sqrt((2*(m/2)^2));
 else
   nRadius = 3*sampSpacing;
 end
 noVol = nRadius + 1;
 
 % Initialize matrices!
 nNeighbors = round(8*nGray/nSamp);
 xSampNeighbors = zeros(nSamp,nNeighbors);
 dSampNeighbors = zeros(nSamp,nNeighbors);

 for ii=1:nSamp
   tic;
   startPt = xSampGray(ii);
   vDist = mrManDist(grayNodes, grayEdges, startPt, ...
                      dimdist, noVol, nRadius);
		  
   % Save the gray matter index of points closer than 'nRadius'
   % and are also in unfList (i.e. have positive distances).
   l = find((vDist <= nRadius));

   % Sort the points by how close they are to the sample point
   % and save the gray matter index and distance of the closest ones.
   [d indx] = sort(vDist(l));
   n = min(length(l),nNeighbors);
   xSampNeighbors(ii,1:n) = l(indx(1:n));
   dSampNeighbors(ii,1:n) = d(1:n);
 
   % Check how much longer.
   if rem(ii,25) == 0
     t=toc;
     s = sprintf('%d pts left. Minutes remaining: %.1f', ...
                 nSamp-ii,1.2*t/60*(nSamp - ii));
     disp(s)
   end
 end

% Saving is now done in Unfold, not here
%
return

%% Optional: If the following lines are de-commented then you can 
%% visualize the distances of gray matter points to the sample points.
%
% imagesc(dSampNeighbors)
% colormap(gray(64));
% axis image
% colorbar('v')

%%%%
