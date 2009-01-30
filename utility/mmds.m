function endConfig = mmds(nPnts,ptsAndDist)
%
%   endConfig = mmds(pointsAndDistance)
%
%AUTHOR:  Wandell
%DATE:    11.10.94
%PURPOSE: 
%   This is an interface to Toky Hel-Or's metric multidimensional
%   scaling routine.  The routine can take incomplete distance
%   matrices.
%
%ARGUMENT:
%  nPnts:  The number of points
%
%  ptsAndDist: An N x 3 matrix whose first two columns
%   contain the integer values describing pairs of points.  The third
%   column contains the distance between the two points.
%
%RETURN:
%  endConfig:  An N x 2 matrix containing the two-dimensional
%   coordinates of the points at locations whose distance matrix
%   matches the input data
%
%	The routine works simply by a large minimization.
%
%HISTORY:
% 08.22.95:  Forced Nx2, not 2xN return, BW

%DEBUG
% ptsAndDist = 10*rand(10,3);
% nPnts = 3
% First, put out the number of data points.
%
pt1 = round(ptsAndDist(:,1));
pt2 = round(ptsAndDist(:,2));
dist = ptsAndDist(:,3);

fp = fopen('dataDistances','w');
fprintf(fp,'%d \n',nPnts);

% Now, write the distances out in the form of
% pnt1 pnt2 distance
%

for i = 1:size(ptsAndDist,1)
  fprintf(fp,'%d %d %f\n',pt1(i),pt2(i),dist(i));
end
fclose(fp);

%	Here is the call to the C-routine.  It reads in the data
% matrix and writes out the points as an nPnts x 2 collection of values.
%
disp('calling mmds ...')
unix('/usr/local/bin/mmds dataDistances 2 > endConfig');
disp('done.')

%  Now, read in the two-dimensional points.  The first column
%contains the x coords and the second the y coords
%
load -ascii endConfig

% Now, clean up the mess you made.
%
unix('rm dataDistances endConfig');

