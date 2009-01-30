% distanceMatrix.m
% ----------------
%
% function estDist = distanceMatrix(coords, dimen)
%
%
%  AUTHOR: Athos Georghiades, Brian Wandell
%    DATE: April 1, 1996
% PURPOSE: 
%         Compute the Euclidian-distance matrix between a set of 
%         points whose coordinates are in the rows of coords.
%
% ARGUMENTS:
%         coords: The coordinates of each point is contained in a row.  
%                 Hence, if there are ten points in a three dimensional 
%                 space, coords is has a size of 10 x 3.
%          dimen: This is the number of dimensions of the points.
%                 Note that the 'dimen' should equal to size(coords,2). 
%
% RETURNS:
%        estDist: The symmetric distance matrix. It is nPoints x nPoints,
%	          so, if coords in 10 x 3, estDist is 10 x 10 (symmetric.)
%                 Note that  nPoints = size(coords,1).
%

function estDist = distanceMatrix(coords, dimen)


%% Check the input arguments. If number of arguments is less than 2 then
%% dimen is set equal to the number of columns in coords. Else check if
%% the number of columns in coords is equal to dimen.
%
 if nargin < 2,
   dimen = size(coords,2);

 elseif  dimen ~= size(coords,2)
   error('distanceMatrix: Number of columns in coords is not equal to dimen') 
 end


%% Get the number of points. 
%
 nPoints = size(coords,1);


%% Initialize estDist the matrix of size  nPoints x nPoints.
%
 estDist = zeros(nPoints,nPoints);


%% Initialize a temporary matrix, tempDist, of size nPoints x nPoints. 
%% As we loop through each dimension (column) of  coords (see next
%% step), tempDist is set equal to  "coords(:,i)*ones(1,nPoints)" 
%% where 1<i<nPoints is an index. That is, it contains nPoints copies 
%% of the i_th column of coords.  
%
 tempDist= zeros(nPoints,nPoints); 


%% Go on and loop through each dimension (that is through each column)
%% summing up the squared  differences.
%
 for i=1:dimen,

   tempDist = coords(:,i)*ones(1,nPoints);

   % The trick here is this:
   % The entries of the matrix (tempDist - tempDist')
   % are the differences between this coordinate values of
   % the i_th and j_th point on the list.  We square these
   % differences and add them up to get the squared distance
   %
   estDist = estDist +(tempDist-tempDist').^2;

 end 


%% The square root of this matrix is now the interpoint distances.
%
 estDist = sqrt(estDist);


%%%%
