% 
% Sample uniformly along the surface
%
% smpCrds.m
% --------------
%
% function xSampGray =  ...
%    smpCrds(grayNodes, grayEdges, sampleSpacing, dimdist, unfList)
%
%  AUTHOR: Brian Wandell
%    DATE: July 8, 1995
% PURPOSE:
%    Sample the gray matter graph for unfolding.
%
%
% ARGUMENTS:
%   grayNodes:  from the gray graph
%   grayEdges:  from the gray graph
%   sampleSpacing: 
% 
%       MODERN:  A single number in mm that represents the distance between
%    sample points.  These will be chosen from the unfList within
%    the first layer.
% 
%       BACKWARDS:  A 3 vector that represents the [dr dc dz]
%     sample spacing. These must be integer. These must be integer
%     values to indicate how many rows and columns to skip. 
%   
%   dimdist: (mm)
%   
%   	The distance between sample points on the anatomical
%   grid, in millimeters.  This and the other variables must be passed 
%   if using the MODERN method.
%   
%   unfList:
%      The list of grayNode indices that will be unfolded.
%
% RETURNS:
%          xSampGray: The node index of sample points that fall 
%                  both in the sampling grid and in the gray matter.
%
% DEPENDENCIES:
%         This file needs these other functions:
%            (a) mrCreatePlaneCoords.m
%            (b) createVolumeVector.m
%            (c) mrShowImage.m
% 
%MODIFIED:  1/22/97, BW and PT
%	   10.22.97  SC for Matlab 5.0 compatibility


function xSampGray =  ...
    smpCrds(grayNodes, grayEdges, sampleSpacing, dimdist, unfList)


%% If the number of arguments is less than 2 then exit with error message.
%
 if nargin < 2
   error('smpCrds:  Not enough arguments')
 end

% DEBUGGING
%
% filename = '/Net/grey/gusr2/mri/anatomy/ruddock/gy_120196/right/right.gray';
% [grayNodes, grayEdges, vSize] = readGrayGraph(filename);
%
% sampleSpacing = 5;   
% dimdist = [ 1 1 1];
% curNode = 1;
% dist = ...
%	mrManDist(grayNodes, grayEdges, curNode, dimdist,  ...
%	-1, 20);
% unfList = find(dist >= 0);

if length(sampleSpacing) == 1

  numGrayNodes = size(grayNodes,2);

  if nargin < 5
    unfList = [1:numGrayNodes];
  elseif nargin < 4
    error('smpCrds:  Must include dimdist.')
  end

  fprintf('Subsampling layer 1 nodes at %3.2f mm\n',sampleSpacing)

  % First, we mark all nodes as visited.
  % 
  unvisited = 0;  touched = 1; marked = 2;   
  visited = ones(1, numGrayNodes)*touched;
  
  % We want a sample set from the first layer and within the
  % unfList.   So, we find the first layer within the unfList and
  % indicate that we haven't visited there.
  % 
  layer = grayNodes(6,unfList);
  firstLayerL = unfList(find(layer == 1));
  visited(firstLayerL) = zeros(size(firstLayerL));
  
  % This is the number of nodes we have touched
  % 
  numTouched = numGrayNodes - length(firstLayerL);

  while numTouched < numGrayNodes

    l = find(visited == 0);
    curNode = l(1);
    visited(curNode) = marked;

    numTouched = numTouched + 1;
    dist = ...
	mrManDist(grayNodes, grayEdges, curNode, dimdist,  ...
	unvisited, sampleSpacing);

    l = find(dist > 0);
    
    if ~isempty(l)
      unTouchedList = find(visited(l) == 0);
    else
      unTouchedList = [];
    end

    visited(l(unTouchedList)) = ...
	ones(size(visited(l(unTouchedList))))*touched;
    
    numTouched = numTouched + length(unTouchedList);

  end

  xSampGray = find(visited == marked);
  
else

  fprintf('Using the OLD sampling method.  Please change param file.\n');

  %   For backwards compatibility, we left this in here.  This
  %   section samples on a uniform grid.

  %% If the sampling grid spacings are not in integer values then exit with 
  %% an error message.
  %
  if round(sampleSpacing) ~= sampleSpacing
    error('smpCrds: sample spacing must contain integers')
  end

  %% If the number of arguments is equal to 2 then the 'sampleSpacing' is
  %% set to [1 1 1], that is all the gray points are included in the sample
  %% set.
  %
  if nargin < 3
    disp('Using default sample spacing, [1 1 1]')
    sampleSpacing = [1 1 1];
  end


  %% Initialize parameters used in the sampling process.
  %
  ySpacing = sampleSpacing(1);
  xSpacing = sampleSpacing(2);
  zSpacing = sampleSpacing(3);

  % Return node indices of all gray matter nodes falling
  % on the sampling grid and who belong to layer 1.
  xSampGray = find((rem(grayNodes(1,:), xSpacing)==0) & ...
      (rem(grayNodes(2,:), ySpacing)==0) & ...
      (rem(grayNodes(3,:), zSpacing)==0) & ...
      (grayNodes(6,:)==1));

end
  
return;

%%%%

% Plot distribution of minimum distances between pairs
% of subsampled nodes.

bigVal = 999;
markedNodes = find(visited==2);
minDists = size(1, length(markedNodes));
for i = 1 : length(markedNodes)
  markNode = markedNodes(i);
  dist = mrManDist(grayNodes, grayEdges, markNode, dimdist, ...
       bigVal, sampleSpacing*2);
  dist(markNode) = bigVal;
  i, minDist = min(dist(markedNodes))
  minDists(i) = minDist;
end

hist(minDists);




