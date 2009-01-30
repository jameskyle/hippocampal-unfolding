
% unfoldSqueeze.m
% --------------
%
% gLocs2d = unfoldSqueeze(sampLocs2d, gLocs2d, ...
%            grayNodes, grayEdges, layer, sampSpacing, dimdist, ...
%            squeezeList);
%
%  AUTHOR: Brian Wandell
%    DATE: January, 1997
% PURPOSE:
%         This code finds the two-dimensional positions for gray 
%         matter points in the 2nd and beyond layers.
%
%         Algorithm:
%         Each point is mapped to the position of the closest
%         layer 1 point.
%
% ARGUMENTS:
%    sampLocs2d: The 2d locations of the sample points.
%		 04.02.98 SJC -- sampLocs2d is not used by this
%		 function at all.  We should eliminate it from the
%		 list of input parameters.
%
%       gLocs2d: Two 2d locations of gray matter points.  On
%                entry it contains the sample point and first
%                layer positions.  On return it contains all gray.
%    grayNodes:  Nodes from mrGray.
%    grayEdges:  Edges from mrGray
%        layer:  Which layer for each gray node.
%  sampSpacing:  Spacing of the sample point.
%      dimdist:  Dimension spacing for the gray-matter graph
%  squeezeList:  List of gray matter positions that should be
%                 squeezed down to a first layer point by this
%                 routine. 
%
% DEPENDENCIES:
%         This file needs these other functions:
%           (a) movePointPlaneErr.m
%           (b) movePointPlaneGrad.m
%
% REVISIONS:
% 10.13.97 SC modified to run on Matlab 5.0
%

function gLocs2d = unfoldSqueeze(sampLoc2d, gLocs2d, ...
    grayNodes, grayEdges, layer, sampSpacing, dimdist, ...
    squeezeList)

% gLocs2d starts with the sample point locations and the first
% layer locations.  We fill in the rest here.

% We place the points in squeezeList at the same location as the
% closest layer 1 point. 

% Check that and squeezeList are within bounds
 if( max(squeezeList) > size(gLocs2d,1) | min(squeezeList) < 1 )
   error('squeezeList values out of range.')
 end

nSqueeze = length(squeezeList);
notReachedVal = -1;
count = 0;
redo = 0;

for i=squeezeList

  tic

  % Find all the points within a small radius and in layer 1
  firstLayer = []; 

  dist = ...
      mrManDist(grayNodes,grayEdges,i,dimdist,notReachedVal, 1.5*sampSpacing);
  
  % Find the closest layer 1 point.  These are relative to gray matter
  nearbyPoints = find(dist > 0);

  % Find the nearby points in the first layer.  These are
  % relative to the nearbyPoints.  nearbyPoints(firstLayer) are
  % the position in the gray matter list.
  firstLayer = find(layer(nearbyPoints) == 1);

  if isempty(firstLayer)

    redo = redo+1;
    
    % We didn't look far enough, try again.
    dist =  ...
	mrManDist(grayNodes,grayEdges,i,dimdist,notReachedVal,5*sampSpacing);
    nearbyPoints = find(dist > 0);
    firstLayer = find(layer(nearbyPoints) == 1);

    if isempty(firstLayer)
      error('unfoldSqueeze:  bad sample point positions')
    else
      [u v] = min(dist(nearbyPoints(firstLayer)));
    end

  else
    [u v] = min(dist(nearbyPoints(firstLayer)));
  end
    
  % Assign that location to this point
  idx = nearbyPoints(firstLayer(v));
  gLocs2d(i,:) = gLocs2d(idx,:);

  % Keep counting
  count = count+1;
  if (rem(count,200) == 0)  
    t = toc; 
    fprintf('%4.0f points left. %.1f (min)\n', ...
	(nSqueeze - count),t*(nSqueeze - count)/60); 
  end

end

fprintf('Had to redo %4.0f points\n',redo)

return;






