% unfoldFlatten.m
% ---------------
%
% function [locs]=unfoldFlatten(mDist, locsInitial, flatWeight, rSamp, ...
%                               P, sampSpacing, saveDir, nIter, penalty_num,M,rSeed)
%
%
%  AUTHOR: Brian Wandell, Athos Georghiades
%    DATE: October, 1995
% PURPOSE:
%         This function iteratively computes a set of point locations 
%         in three space that are (1) as close as possible to a plane 
%         and that (2) whose Euclidean distances 
%         are the same as the Cortical distances stored in mDist.
%
% ARGUMENTS: 
%           mDist: Matrix of distances along the manifold between 
%                  sample points (measured within the cortex). 
%                  (Size: nSamp x nSamp)
%     locsInitial: Zero-mean initial locations in 3 space of the sample gray
%                  matter points.
%                  (Size: nSamp x 3)
%      flatWeight: The maximum bias weight in favor of the sum of the 
%                  square of the perpenticular distance of the points from
%                  the "flattening" plane. You can think of this as the 
%                  maximum "importance" of having the points as close as 
%                  possible to the flattening plane relative to keeping the
%                  inter-distance relationships the same as the manifold
%                  distances stored in mDist
%           rSamp: Number of neighbors used in finding the new position of
%                  each point in the set of sample points.
%               P: Perpendicular to the flattening plane.
%     sampSpacing: The sub-sampling spacing in the x,y and z directions.
%  07.02.98 SJC -- sampSpacing is not used by unfoldFlatten
%
%         saveDir: String that stores the path of the directory in which 
%                  the outputs are saved. 
%           nIter: Total number of iterations executed.
%     penalty_num: Penalty function for the error
%               M: Penalty function parameter, only needed for function 6
%	    rSeed: The seed for the random number generator
%
% RETURNS:
%
%  locs:  
%  	These are 3d positions assigned to the points in
%  	locsInitial such that the distances are preserved as well
%  	as possible and the points are close to a plane defined
%  	by P.
%
%
% DEPENDENCIES:
%         This file needs these other functions:
%           (a) selectNeighbors.m
%           (b) movePointErr.m
%           (c) movePointGrad.m
%
% REVISIONS:
% 10.14.97 SC removed gradient as input to least squares estimation because
%             |dp - dm| is now used as error measure
%             Added penalty function selection as input to this function.
%             The penalty function number should be passed as input to
%             movePointErr()
% 10.17.97 SC Added M as parameter for the penalty function
% 06.26.98 SC Added rSeed, the random number seed, as an optional input
%	      parameter (to be passed to selectNeighbors.m)
%

function [locs, totalErr]= ...
    unfoldFlatten(mDist, locsInitial, flatWeight, rSamp, ...
    P, sampSpacing, saveDir, nIter, penalty_num, M, rSeed)

%% If no random number seed was passed, make it zero
%
if (nargin < 11)
  rSeed = 0;
end

%% Get the current directory and store it in curDir.
% 
 curDir = cd;

%% Normalize vector P.
%
 P = P / norm(P,2);


%% Set up the leastsq search method for an efficient search strategy.
%
 % Copy default foptions to a new vector options so that we can modify it.
  options = foptions;
 
 % Use line search algorithm.
  options(7) = 1;     
 
 % Set measure of precision required for location. 
  options(2) = .02;   

 % Set measure of precision required for the objective function at the 
 % solution.
  options(3) = .02;  

%% Initializations of variables and matrixes before we go into the main loop.
%

 % Set initial "locs" to "locsInitial". 
  locs = locsInitial;

 % Get the number of sample point locations.
  nSamp = size(locs,1);

 % Initialize a matrix of size (nSamp x rSamp) which stores the rSamp
 % indexes of the neighbors of each one of the nSamp sample points.   
 % This matrix is filled in once on the first iteration.
  nPositions = zeros(nSamp, rSamp);


%% Iterative flattening of the sample point set.
%% In each iteration a new position for each individual  
%% sample point is found (inner "for" loop) that minimizes 
%% the the distance from the flattening plane *PLUS* 
%% the sum (over all the neighbors of the sample point) 
%% of the squared differences between 
%% the (squared Euclidean distance) of the sample point to its neighbors
%% and the (squared Cortical distance) stored in mDist.
%   
totalErr = zeros(1,nIter);

for iter=1:nIter

  % DEBUGGING
  % xgobi(locs);
  % keyboard;

  % 07.15.98 -- SJC
  % Hack to test combining regular unfold with inflating to a sphere
  if (iter < 3)
    penalty_num = 1;
  else
    penalty_num = 7;
  end
  if (iter == 3)
    M = sqrt(mean(locs(:,1)).^2 + mean(locs(:,2)).^2 + mean(locs(:,3)).^2)
  end

  fprintf('Beginning iteration 	%d.\n',iter); 
  fweight = flatWeight*(iter/nIter);
  for i=1:nSamp
    if iter==1,
      % When in the first iteration select rSamp+1 neighbors for each of 
      % the nSamp points. These neighbors are used in all the iterations
      % to find the new position of a point.
      tempPos = selectNeighbors(mDist(i,:), rSamp+1, 'r', rSeed);
      
      % Check if a point has as itself as one of its neighbors. Delete
      % it, or delete the last of the selected neighbors so as to keep 
      % a constant number of neighbors (rSamp) for all points. 
      if (length(find(tempPos==i)))
	tempPos(find(tempPos==i))=[];
      else
	tempPos(rSamp)=[];
      end

      % Store the indexes of the neighbors of each point.
      nPositions(i,:)=tempPos;
    end

    % Get the indexes of the neighbors of the i'th point.
    l=nPositions(i,:);

    % Get the manifold distances from the i'th point to its neighbors. 
    iDist = mDist(i,l);

    % Get the coordinates of the neighbors.
    oLocs = locs(l,:);

    % Find the new location of the i'th point using a non-linear least
    % squares algorithm.
        
    tempLoc = leastsq('movePointErr2',locs(i,:),options, ...
	[],oLocs,iDist,fweight,P,penalty_num,M);
%	'movePointGrad',oLocs,iDist,fweight,P,penalty_num,M);
    
    % Do a linear interpolation between the new and the old location
    % of the point and store in locs. 
    % This particular step is important.  The position is updated
    % towards the best position, but only part way.  We have found
    % that if we update to the best position, the solution oscillates.
    % Using this value (half-way) the solution converges more rapidly
    % and doesn't oscillate (is critically damped).  There is room
    % for some theory here.
    locs(i,:) = locs(i,:) + (0.5)*(tempLoc-locs(i,:));    
    err = movePointErr2(locs(i,:),oLocs,iDist,fweight,P,penalty_num);
    totalErr(iter) = totalErr(iter) + sum(err.^2);
  end


  if iter == 1
    thisError = sqrt(totalErr(iter)/nSamp);
    lastError = thisError;
    fprintf('Current error: %f\n',thisError);
  else
    lastError = thisError;
    thisError = sqrt(totalErr(iter)/nSamp);
    reducedError = (lastError - thisError)/lastError;
    fprintf('Current error: %f\n',thisError);
%    if reducedError < 0.00001
%      fprintf('Exit for Percent reduction:  %f\n', reducedError);
%      return;
%    end
  end
    
  % DEBUGGING
  %
  % Finding points with highest error
%   max_err = max(err(:));
%   err_points = find( err >= 0.9*max_err );
%   figure;
%   plot3(locs(:,1),locs(:,2),locs(:,3),'bo');
%   hold on
%   plot3(locs(err_points,1),locs(err_points,2),locs(err_points,3),'rx'); % Points with most error
%   plot3(locs(1226,1),locs(1226,2),locs(1226,3),'rx');                   % Bad point
%   hold off
%   axis equal
  % view(45,30)
  % keyboard   
end


%%%%


