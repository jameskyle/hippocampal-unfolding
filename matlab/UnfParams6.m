% UnfParams6.m
% Parameters File for Unfolding, updated 6-12-03

% This file creates and sets the parameters needed by Unfold.
% This file is eval'd at the beginning of Unfold so that the
% parameter values set here are available as Unfold runs.

% 1.  Bookkeeping stuff
% 
% Set up the path (including the name of the .mat file)
% for loading the raw data. 
%
graphFile='d396_finalinterp_grayleft_NEW';

% Set up directory path for saving the results.
%
saveDir = '.';

% 2.  Gray matter information 

% These are the dimensions of the voxels in the volume anatomy.
% Voxel values should be in mm/pixel.  Often, we compute them
% from the field of view and number of pixels in the image and
% stuff like this, as in

xmmpix = 200/512;
ymmpix = 200/512;
zmmpix = 3/7;   % Engel's brain, others are 1.2 or 1.0

% The key variable that is used by Unfold is dimdist. If you know
% the numbers already (mm/pix) just enter them here and skip all
% the stuff above.

dimdist = [xmmpix ymmpix zmmpix]

% We commonly do our unfolds by picking a start point and
% then identifying all gray matter nodes within a certain
% distance of the start point.  In fact, given the way our
% algorithm works this is the right thing to do.  This next
% section of code helps  you do that with the tools in this
% distribution.

% First define start point in gray matter.  You can find it using
% the crossbars in mrGray.  Place the red, green and blue
% crossbars at the start point, and then read the positions of
% those bars.  Place them as shown below.  
% startPoint = [Red Green Blue];


startPoint = [52 105 254];
%startPoint = [49 47 89];

% Identify the index into the gray matter nodes corresponding to
% the start point.
% [nodes, edges, vSize] = readGrayGraph4(graphFile);
[nodes, edges, vSize] = readGrayGraph(graphFile);
[i,j] = find( (nodes(1,:)==startPoint(1,3)) & ...
    (nodes(2,:)==startPoint(1,2)) & ...
    (nodes(3,:)==startPoint(1,1)));
startNode = j

if (startNode == 0)
	err('StarPoint not in Gray matter!!');
end

% Define the radius (mm) of the unfold region.  The key variable
% here is unfList which defines the set of points that will be
% unfolded. 
% 
radius = 150;
[dist nPntsReached] = mrManDist(nodes,edges,startNode,dimdist,-1,radius);
unfList = find(dist > 0);
fprintf('Unfolding %4.0f points; %2.0f mm from calcarine fundus.\n', ...
    length(unfList), radius);

% 3.  Iterative/stochastic algorithm parameters

% The routine unfoldFlatten first places a subset of the first
% layer points on the plane (sample points) and then places the
% remaining points on the plane.  The points in the subset are
% chosen to be roughly equally spaced in the routine smpCrds.m
% Their spacing is set by this variable.

sampSpacing = 1.5;

% unfoldFlatten iterates.  This parameter sets the number of
% iterations for unfoldFlatten before completion.  We should
% really get rid of this parameter and terminate based on the
% rate of error reduction.  I am almost set to make this change
% (see the code) but I just don't have the time (whine).

nIter = 9;

% The flattening algorithm begins with points specified in three
% space (in the brain) and results in points near a plane.  As it
% proceeds, it weights the importance of being properly spaced
% and near a plane differently.  This parameter sets the maximum
% bias weight in favor of the sum of the square of the
% perpendicular distance of the points from the "flattening"
% plane. You can think of this as the maximum "importance" of
% having the points as close as possible to the flattening plane
% relative to keeping the inter-distance relationships the same
% as the manifold distances stored in mDist.  I have no idea
% whether this is a good choice.  Sigh.  But it works OK for now.

flatWeight = 12;

% The flattening algorithm positions each point using a
% stochastic algorithm. This parameter sets the number of
% neighbors used in finding the new position of each point in the
% set of sample points.

rSamp = 35;  % Used to be 35

% Set the perpendicular to the flattening plane (thus defining the 
% flattening plane).  The algorithm seems to converge for
% virtually any plane we chose.  Anyway, here is one possible
% perpendicular. 
% 

P = [1 0 0];





