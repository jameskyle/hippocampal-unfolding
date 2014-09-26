% gridImage.m
% -----------
%
% function [imUnfold, rowF, colF] = 
%          gridImage(sFactor, locs2d, data, noDataVal);
%
% 
% AUTHORS: B. Wandell, S. Engel
%    DATE: November, 1995
% PURPOSE: 
%          Makes an image of "data" by placing each value at the corresponding 
%          locations specified by locs2d. One pixel per unit in locs2d is 
%          being used. Note that "data" and locs2d must have the same number 
%          of entries (rows).  
%
% ARGUMENTS:
%          sFactor : Scales the size of the returned image. Must be 
%                    an integer.
%           locs2d : Flattened 2D locations.
%             data : Contains the plane from which each point
%                    came from. 
%        noDataVal : Default value of initialized image. When not 
%                    passed then it is set to 0.
%
%
% COMMENTS:
%% In some cases, you may want to know the actual coordinates of the
%% row and column positions.  In that case, you can use
%%
%%     image(imUnfold,'Xdata',[ min(locs2d(:,1), max(locs2d(:,1)],
%%		      'Ydata',[ min(locs2d(:,2), max(locs2d(:,2)])
%
% MODIFICATIONS:
%Last Modified/9.26 - GMB,BW
% 10.16.97 SC - made the default noDataVal NaN instead of 0
%


function [imUnfold,rowF,colF] = gridImage(sFactor,locs2d,data,noDataVal);

%% If noDataVal is not passed then set it equal to NaN.
%
 if (nargin == 3)
   noDataVal = NaN;
 end


%% If data and locs2d do not have the same number of rows then exit with
%% an error message.
%
 if (size(locs2d,1) ~= size(data,1))
   error('gridImage: data and locs2d must be same size');
 end


%% Get the row and column index vectors (in pixels) for each of
%% the points  
%% in locs2d starting from 1 in each direction.
%
 mn(1) = min(locs2d(:,1)); mn(2) = min(locs2d(:,2));

%% For each point, create its row and column positions
%% in the image
%
 colF = floor( sFactor*(locs2d(:,1) - mn(1)) + 1);
 rowF = floor( sFactor*(locs2d(:,2) - mn(2)) + 1);

%% Create an image of size of max(row) x max(column)
%% The initial (default value of the image is noDataVal).
%
 imUnfold = noDataVal*ones(ceil(max(rowF)), ceil(max(colF)));

%% For every point in the data set, assign the plane it came from to
%% the imUnfold image.  The unassigned points stay at noDataVal
%
 nPnts = size(locs2d,1);
 for i=1:nPnts
   imUnfold(rowF(i),colF(i)) = data(i);
 end

%%%%
