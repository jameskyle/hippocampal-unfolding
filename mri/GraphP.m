% GraphP.m

%% Set up the path (including the name of the .mat file)
%% for loading the raw data. 
%
 volumeDataFile='newpatch';
 graphFile='Graph.gray';

%% Set up directory path for saving the results.
%
 saveDir = './';


%% Variable initializations used in unfoldDist.
%
 % Define the size of each voxel in millimeters. 
 dimdist = [1.0667 1.0667 1.0000];

 % Define the sub-sampling ratio of the volume in each dimension. 
 sampSpacing = 2.5;

 % Load up the selected gray matter from the graph file
 % 
 [nodes edges vSize] = readGrayGraph(graphFile);

 % Set the index into gray matter nodes to initiate the 'mrManDist'command
 % and the radius for picking out the gray-matter for this unfold
 %
 startPoint = 100;
 radius = 15;
 [dist nPntsReached] = mrManDist(nodes,edges,startPoint,dimdist,-1,radius);

 % Tell the user how we did
 % 
 nPntsReached
 unfList = find(dist >= 0);
 startPoint = find(unfList == startPoint);
 fprintf('Unfolding %d points out of %d.\n',length(unfList), size(nodes,2));

 % Starting with version 3.1
 % 
 % cutFile: A string defining the name of a matlab file
 % containing a list of indices that point into the first layer
 % points in that part of the gray matter graph that will be %
 % unfolded.  These points will be removed before unfolding.  %
 % The order of point removal is important.  The original gray %
 % graph is reduced by unfList. The indices in cutFile should %
 % point to first layer points in this reduced graph that will %
 % be removed.

 cutFile = 'TestCut';

 %% Variable initializations for the flattening (unfoldFlatten).

 %
 %Set the total number of iterations.
 nIter = 10;

 % Set the number of iterations between saves of outputs in unfoldFlaten.
 writeInterval = 1;   

 % Set the maximum bias weight in favor of the sum of the 
 % square of the perpenticular distance of the points from
 % the "flattening" plane. You can think of this as the 
 % maximum "importance" of having the points as close as 
 % possible to the flattening plane relative to keeping the
 % inter-distance relationships the same as the manifold
 % istances stored in mDist. 
 flatWeight = 12;

 % Set number of neighbors used in finding the new position of
 % each point in the set of sample points.
 rSamp = 35;
 
 % Set the perpendicular to the flattening plane (thus defining the 
 % flattening plane).
 P = [-1 1 0] 

 % Select penalty function number
 
 penalty = 6;
 M = 7;
%%%%





