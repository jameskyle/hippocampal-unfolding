% alignPoints.m
% -------------
%
% function  newLocs = alignPoints(locs, operations)
%
%  AUTHOR: Brian Wandell
%    DATE: August 22, 1995
% PURPOSE:
%          Repositions the points in locs so that they are centered 
%          around the origin and have their least direction of variation 
%          in the z-axis. The 2nd argument turns on/off the operations of:
%           (a) centering to the origin;
%           (b) rotating so that max variation is in the x direction and 
%               least in the z;
%           (c) scaling so that the absolute value of the largest value is 1.
%
% ARGUMENTS:
%          locs: Locations in the rows of the matrix (Size: nPoints x 3).
%    operations: A string that may contain c,r,s depending on whether
%                you want to center, rotate, or scale. For example
%                operations = 'cr' will center and rotate.
%
% RETURNS:
%       newLocs: New locations in the rows (Size: nPoints x 3)
%
%
% DEPENDANCIES:
%         This file needs these other functions:
%           (a) mmax.m
%


function newLocs = alignPoints(locs, operations)


%% Get number of points.
%
 nPoints = size(locs,1);


%% Decipher which operations should be carried out on the points.
%
 center = 0; 
 rotate = 0;
 scale = 0;
 if nargin > 1
   if (find(operations == 'c'))
     center = 1;
   end
   if (find(operations == 'r'))
     rotate = 1;
   end
   if (find(operations == 's'))
     scale = 1;
   end
 else
   % Just center if no 'operations' argument.
   center = 1;
 end


%% Initialize the 'newLocs' matrix.
%
 newLocs = locs;

%% Shift data to the origin.
%
 if center == 1,
   meanLoc = mean(newLocs);
   newLocs = newLocs - meanLoc(ones(1,nPoints),:);
 end

%% Rotate the coordinates so that the principal direction of
%% variation is in the x plane, next in the y plane and least in z.
%
 if rotate == 1
   [u s v] = svd(newLocs'*newLocs);
   newLocs = newLocs*u;
 end

%% Scale the coordinates so that the largest absolute value is 1.
%
 if scale == 1
   scaleFactor = mmax(abs(newLocs));
   newLocs = newLocs ./scaleFactor;
 end


%%%%
