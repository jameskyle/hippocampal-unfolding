% unfoldInterp.m
% --------------
%
% gLocs2d = unfoldInterp(sampLocs2d, gLocs2d, dSampNeighbors,...
%                        xSampNeighbors, xSampGray, penalty_num, M)
%
%  AUTHOR: Brian Wandell
%    DATE: October, 1995
% PURPOSE:
%         This code finds the two-dimensional positions for all the gray 
%         matter points that were not among the original sample locations.
%         The quantities needed by this script are computed by unfoldDist
%         and unfoldFlatten.
%
%         Algorithm:
%
%         The function unfoldDist measures the distance matrix between each
%         sample point and its neighbors.
%         It creates two related matrices used here:
%           dSampNeighbors: the distances between sample points and their 
%                           neighbors,
%           xSampNeighbors: the indices of the neighbors
%  
%         This routine, unfoldInterp, uses xSampNeighbor to find the sample 
%         points near each gray-matter point. Then each gray-matter point is 
%         assigned a position in the plane (using the 'leastsq' function as 
%         in unfoldFlatten) at a location that matches the distances to the 
%         sample points as much as possible. These distances are stored in 
%         dSampNeighbor (and as in mDist they represent manifold distances).
%
%
% ARGUMENTS:
%        sampLocs2d: The 2d locations of the sample points.
%           glocs2d: The current list of 2d locations of all first
%                    layer gray nodes.  On entry, this contains only
%                    the locations of the sample points.  On
%                    return, the locations of all the layer 1 points
%                    are added.
%   dSampNeighbors : Distances between sample points and 'nNeighbors'
%                    neighboring gray matter points. Calculated in unfoldDist.
%                    (Size: nSamp x nNeighbors)
%   xSampNeighbors : Matrix of gray matter indices to same points, as in
%                    'dSampNeighbors' matrix, that are neighbors of the 
%                    sample points. Calculated in unfoldDist. 
%                    (Size: nSamp x nNeighbors)
%        xSampGray : The index function from the sample points to
%                    the first layer gray matter points.
%                    (Size: 1 x nSamp)
%       penalty_num: Penalty function for the error
%                 M: Penalty function parameter, only needed for function 6
%
%
% Recent modification:  1/24/97, 5/2/97 BW
% 10.14.97 SC removed gradient as input to least squares estimation because
%             |dp - dm| is now used as error measure
%             Added penalty function selection as input to this function.
%             The penalty function number should be passed as input to
%             movePointPlaneErr()
% 10.17.97 SC Added M as parameter for the penalty function
%


function gLocs2d = unfoldInterp(sampLocs2d, gLocs2d, ...
    dSampNeighbors, xSampNeighbors, xSampGray, penalty_num, M)

 % Set up the leastsq search method for an efficient search strategy.

 % Copy default foptions to a new vector options so that we can modify it.
  options = optimset;
  options = optimset('LineSearchType','quadcubic',...
                     'TolX', .002,...
                     'TolF', .002);
 
 % Initialize the number of points not interpolated.
 nMissed = 0;

 % Go into the main loop and assign a location to each point in the 
 % gray-matter. Note that no assignment is done for the sample points
 % as it is not required.

 count = 0;
 nPoints = size(gLocs2d,1);
 for i=1:nPoints

   % If not a sample point then interpolate.
   if (~length(find(xSampGray == i)))

     tic
     % Get the indexes of the neighbors of the i'th point.
     [r c] = find(xSampNeighbors == i);  
      
     % Get the number of neighbors.
     nNeighbors =  length(r);

     % Find the distances between these sample point neighbors and the
     % i'th gray matter point.
     nDist = zeros(1,nNeighbors);
     for j=1:nNeighbors, 
       nDist(j) = dSampNeighbors(r(j),c(j)); 
     end

     % Get the 2D locations of these neighboring sample points.
     nLocs = sampLocs2d(r,:);

     % If the point has more thet 3 neighbors then find the location of 
     % this gray matter point within the plane so that it matches the 
     % distances to the set of neighboring points.
     %
     if (nNeighbors < 3) gLocs2d(i,:) = [NaN NaN]; 
       nMissed = nMissed + 1;
     else
       gLocs2d(i,:) = lsqnonlin('movePointPlaneErr',mean(nLocs),[],[],options, ...
			      nLocs,nDist,penalty_num,M);
%                              'movePointPlaneGrad',nLocs,nDist,penalty_num,M);
     end

     count = count+1;

     % Print how much more time...
     if (rem(i,100) == 0)  
       t = toc; 
       fprintf('%4.0f left. Minutes:  %.1f\n', ...
	   (nPoints-count),t*(nPoints - count)/60); 
     end
   end
 end

 fprintf('Missed %3.0f points\n',nMissed);
 
 return;

%%%%






