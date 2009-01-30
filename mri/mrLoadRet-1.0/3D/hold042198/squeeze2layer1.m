function [layer1map, unfLayer1] = squeeze2layer1(grayNodes, grayEdges, unfList, dimdist)
% function data_out = squeeze2layer1(grayNodes, grayEdges, unfList, dimdist);
%
% AUTHOR: SJC, APB
% DATE: 04.02.98
% PURPOSE:
%	  Maps all points not on the first layer to the closest first layer
%	  point to it.  'layer1map' is a vector that indicates to which first
%	  layer node each point should be mapped to.
%
%	  Code from unfoldSqueeze.m was used as a model.
%
% ARGUMENTS:
%	grayNodes, grayEdges: gray matter graph
%	unfList:	list of nodes that were unfolded
%	dimdist:	array of y, x and z separations between points
%
% RETURNS:
%	layer1map:	vector that indicates the index of the first layer
%			node that each point should be mapped to.
%

% We have arbitrarily selected this radius within which to search for the closest
% layer 1 point
radius = 5*max(dimdist);
noVol = 10*radius;

% Find all points on the first layer that were unfolded
unfLayer1 = find(grayNodes(6,unfList) == 1);

% Find the layer for all unfolded points
layer = grayNodes(6,unfList);

for ii = 1:length(unfList)
  % If the point is on the first layer, it maps to itself
  if (layer(ii) == 1)
    layer1map(ii) = ii;

  % Otherwise, we need to find the closest first layer point to it
  else
    % Find distance from this data point to all other data points
    dist = mrManDist(grayNodes,grayEdges,unfList(ii),dimdist,noVol,radius);
    
    % Only use distances to unfolded points
    unfDist = dist(unfList);
    
    % Find closest layer1 point to this data point and map to it
    [minDist idx] = min(unfDist(unfLayer1));
    layer1map(ii) = unfLayer1(idx);
  
  end
  
  if (rem(ii,500) == 0)
    disp(sprintf('squeeze2layer1: mapping point %d out of %d...',ii,length(unfList)));
  end    

end