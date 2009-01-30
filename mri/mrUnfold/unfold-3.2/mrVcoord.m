% mrVcoord.m
% ----------
%
% function res = mrVcoord(inData, iSize)
% 
%  AUTHOR: Brian Wandell
%    DATE: July, 1995
% PURPOSE:
%          Computes the (x,y,z) coordinates of a point defined by an 
%          index in a vector volume, or conversely computes the vector 
%          volume index from the (x,y,z) coordinates. 
%
%          The data passed in 'inData' should always be placed in the 
%          columns, so that (in the case you pass the 3D coordinates)
%          inData(:,1) should contain the x coordinates, inData(:,3) 
%          the z coordinates. If you pass the volume indeces these
%          should be in a column.
% 
%          The numbering of the locations follows Matlab convention and
%          begins at 1, not zero.
%
%          In volumes, (x,y,z) correspond just to what you think they 
%          should: (x,y) are within a single image and z denotes which image.
%
%          The indices into the volume run down the column. So, the entry 
%          at [1 10] is the 10th entry in the volume. If there are 10 rows, 
%          the entry at [10 1] is the 101st entry in the volume.
%
%          N.B.:  rows -> y and cols -> x.
%
% ARGUMENTS:
%          inData: This is either a scalar-index column vector volume   
%                  OR 3D (x,y,z) vectors.
%           iSize: Image (or slice) size in the 3D volume. 
%
%   RETURNS:
%          res: If the input is a scalar, then the output is a 3D vector 
%	        describing the location of the index.
%               If the input is a 3D vector, then the output is a scalar 
%               index that will access the proper vector volume element.
%
% DEPENDANCIES:
%         This file needs these other functions:
%           (a) mod.m
%
%


function res = mrVcoord(inData, iSize)


%% Check that the number of arguments is equal to 2. If not then exit
%% with an error message.
%
 if nargin ~= 2
   error('mrVcoord: 2 arguments required');
 end


%% Make sure that 'iSize', not 'vSize' has been passed.
%
 if prod(size(iSize,2)) ~= 2
   error('mrVcoord: iSize variable suspicious')
 end


%% If scalar indeces have been passed then return 3D coordinates.
%
 if size(inData,2) == 1 

  % For this logic to work, the list counting must begin
  % at zero.  So, we subtract 1 from inData since Matlab
  % lists begin with 1.
  %
  z = floor( (inData-1) ./ prod(iSize)) + 1;

  xyIndex = mod((inData-1),prod(iSize));
  x = floor(xyIndex ./ iSize(1) ) + 1;
  y = mod(xyIndex,iSize(1)) + 1;
  res = [x,y,z];


%% If 3D coordinates have been passed then return scalar indeces.
%
 elseif size(inData,2) == 3 
   res = inData(:,2) + (inData(:,1)-1)*iSize(1) + (inData(:,3)-1)*prod(iSize);


%% If arguments have were not in columns then exit with an 
%% error message.
%
 else
   error('mrVcoord: Arguments must be in the columns')
 end


%%%%