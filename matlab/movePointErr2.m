% movePointErr.m
% --------------
%
% function totalErr = movePointErr(x,neighborLocs,iDist,flatWeight,P,...
%					penalty_num,M)
%
%
%  AUTHOR: Brian Wandell
%    DATE: October, 1995
% PURPOSE:  
%         Minimization error function for adjusting point positions
%         in the three-dimensional flattening. This is a call back 
%         function used by the unfoldFlatten.
%         It returns a vector, totalErr, of error values with each element
%         corresponding to a difference between "the squared distance of x
%         to one of the neighbors" and "the corresponding squared manifold 
%         distances". The only exception is the last element of totalErr 
%         which contains the square of the perpendicular distance of x to 
%         the flatening plane. 
%         The size of totalErr is ((number_of_neighbors +1) x 1).
%
%
% ARGUMENTS:
%              x : The current point location.
%   neighborLocs : The 3D coordinates of selected sample point neighbors.
%           iDist: Manifold distances between this point and its selected 
%                  neighbors.
%      flatWeight: Weight bias for pushing towards the flattening plane.
%               P: Perpendicular to the plane.
%     penalty_num: Penalty function slection for weighting error:
%			1: |dp - dm|
%			2: |dp - dm|.^2
%			3: ln( 1 + |dp - dm| )
%			4: 1 - (0.5).^|dp - dm|
%			5: 1 - dm/dp
%			6: |dp - dm| / (M + dm)
%			7: |dm - ds|   -- EXPERIMENTAL
%			   where ds is the distance between two points
%			   along a sphere centered at the origin
%               M: Radius parameter for penalty functions 6 and 7
%
% MODIFICATIONS:	
% 10.14.97 SC made Matlab 5.0 compatible and added penalty functions for
%             weighing error
% 10.17.97 SC added penalty function 6 and input parameter M for it
% 07.13.98 SC added penalty function 7, for 'flattening/inflating' gray
%	      matter locations to a sphere of radius M (this is experimental)
%

function totalErr = movePointErr( x, neighborLocs, iDist, flatWeight,...
				P, penalty_num, M)

if (nargin < 7), M = 3;
if (nargin < 6), penalty_num = 1; end
end

%% Get the number of neighbors.
%
 n = size(neighborLocs,1);


%% Calculate the difference between each one of the 3 coordinates of x
%% from the corresponding coordinate of all the neighbors.
%
 dx = x(1) - neighborLocs(:,1);
 dy = x(2) - neighborLocs(:,2);
 dz = x(3) - neighborLocs(:,3);


%% Calculate the differences between "the squared distances
%% of x to all of its neighbors" and "the corresponding squared 
%% manifold distances". 
%

 dp = sqrt(dx.^2 + dy.^2 + dz.^2);
 dm = abs(reshape(iDist,n,1));
 dist_diff = abs(dp - dm);
 
 switch penalty_num
   case 2
     err = dist_diff.^2;
   case 3
     err = log( 1 + dist_diff );
   case 4
     err = 1 - (0.5).^dist_diff;
   case 5
     err = 1 - ( dm ./ dp );
   case 6
     err = dist_diff ./ ( M*ones(size(dm)) + dm );
   case 7
     %% EXPERIMENTAL - SJC 07.14.98
     %% Trying to inflate points onto a sphere
     %% Distance between two points will be calculated along a sphere
     %% centered at the origin of radius r (the two points are
     %% assumed to be located on a sphere of radius r centered at
     %% the origin).
     
     % Calculating the normals of the vectors from the origin to
     % each neighboring point.
     % norm = sqrt(x.^2 + y.^2 + z.^2)
     %
     normNeighbors = sqrt(neighborLocs(:,1).^2 + ...
     			  neighborLocs(:,2).^2 + ...
     			  neighborLocs(:,3).^2)';
     
     % Theta is a vector of the angles between the current point and
     % all of its neighbor points.
     % The dot product of two vectors is equal to the product of their
     % normals times the cosine of the angle between them.
     % x * neighborLocs' = norm(x) .* normNeighbors .* cos(theta)
     %
     % 'acos' returns an angle in radians.
     %
     theta = acos((x * neighborLocs') ./ (norm(x) .* normNeighbors));
     
     % The radius of the sphere is the average of the distances from 
     % each point to the origin
     %
     %r = (norm(x) + normNeighbors)./2;

     % The distance between two points along a sphere is just the
     % radius of the sphere times the angle (in radians) between the
     % points.
     %
     %ds = r .* theta;
     
     % What would the distance be if the points were on the sphere
     % that they are being inflated to:
     ds = M .* theta;
     
     err = abs(dm - ds');
     
   otherwise
     err = dist_diff;
 end;

if (penalty_num == 7)
  %% EXPERIMENTAL - SJC 07.14.98
  % Add the inflating/spherical error (error in the equation
  % x^2 + y^2 + z^2 = M^2) at the end of totalErr
  %
  sphereErr = abs(x*x' - M^2);
  totalErr = [err ; n*flatWeight*sphereErr];
else
  % Add the flattening error (squared perpendicular distance of x from the
  % plane) at the end of totalErr.
  %
  totalErr = [err ; n*flatWeight*(P*x')^2];
end

%% Return the vector for leastsq to operate on.

%%%%
