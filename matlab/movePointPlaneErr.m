% movePointPlaneErr.m
% -------------------
%
% function totalErr = movePointPlaneErr(x,neighborLocs,iDist,penalty_num,M)
%
%
%  AUTHOR: Brian Wandell
%    DATE: October, 1995
% PURPOSE:  
%         Minimization error function for adjusting point positions
%         within the plane during the interpolation stage.This is a call back 
%         function used by the unfoldInterp.
%         It returns a vector, totalErr, of error values with each element
%         corresponding to a difference between "the squared distance of x
%         to one of the neighbors" and "the corresponding squared manifold 
%         distances". 
%         The size of totalErr is (number_of_neighbors x 1).
%
%
% ARGUMENTS:
%              x : The current point location.
%   neighborLocs : The 2D coordinates of selected sample point neighbors.
%           iDist: Manifold distances between this point and its selected 
%     penalty_num: Penalty function slection for weighting error:
%                  neighbors.
%			1: |dp - dm|
%			2: |dp - dm|.^2
%			3: ln( 1 + |dp - dm| )
%			4: 1 - (0.5).^|dp - dm|
%			5: 1 - dm/dp
%			6: |dp - dm| / (M + dm)
%               M: Radius parameter for penalty function 6
%
% MODIFICATIONS:	
% 10.14.97 SC made Matlab 5.0 compatible and added penalty functions for
%             weighing error
% 10.17.97 SC added penalty function 6 and input parameter M for it
% 02.12.98 SC fixed bugs with nargin check (used to be 7 and 6, so it would
%             always default to M=3 and penalty function 1 because this
%             function only has 5 inputs).
%
%
 
function [totalErr,G] = movePointPlaneErr(x,neighborLocs,iDist,penalty_num,M)

if (nargin < 5), M = 3;
if (nargin < 4), penalty_num = 1; end
end

%% Get the number of neighbors.
%
 n = size(neighborLocs,1);


%% Calculate the difference between each of the 2 coordinates of x
%% from the corresponding coordinate of all the neighbors.
%
 dx = x(1) - neighborLocs(:,1);
 dy = x(2) - neighborLocs(:,2);


%% Calculate the differences between "the squared distances
%% of x to all of its neighbors" and "the corresponding squared 
%% manifold distances". 
%
 dp = sqrt(dx.^2 + dy.^2);
 dm = abs(reshape(iDist,n,1));
 dist_diff = abs(dp - dm);
 
 switch penalty_num
   case 2
     totalErr = dist_diff.^2;
   case 3
     totalErr = log( 1 + dist_diff );
   case 4
     totalErr = 1 - (0.5).^dist_diff;
   case 5
     totalErr = 1 - ( dm ./ dp );
   case 6
     totalErr = dist_diff ./ ( M*ones(size(dm)) + dm );
   otherwise
     totalErr = dist_diff;
 end;
G = [];
%%%%
