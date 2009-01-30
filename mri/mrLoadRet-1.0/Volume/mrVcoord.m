function res = mrVcoord(inData,iSize)
%
%    res = mrVcoord(inData,iSize)
%
%AUTHOR:  Wandell
%DATE:    July 1995
%PURPOSE:
%
% Compute the xyz coordinates of a point defined by an index in a volume,
% or conversely compute the xyz from the index.  The data passed in
% inData should always be in placed in the columns, so that inData(:,1) 
% contains the x coordinates, inData(:,3) contains the z coordinates.
% 
% The numbering of the locations follows Matlab convention and begins
% at 1, not zero.
%
% In volumes, (x,y,z) correspond just to what you think they should:
% (x,y) are within a single image and z denotes which image.
%
% The indices into  volumes run down the columns.  So, the entry at [1 10]
% is the 10th entry in the volume.  If there are 10 rows, the entry at
% [10 1] is the 101st entry in the volume.
%
% N.B.:  rows -> y and cols -> x.
%
%ARGUMENTS:
%
% inData:  This is either a scalar index or a 3d (x,y,z) vector.
% iSize: image size of elements of the volume.
%
%RETURNS:
%
% res:   If the input is a scalar, then the output is the 3d vector 
%	 describing the location of the index.
%        If the input is a 3d vector, then the output is a scalar index
%	 that will access the proper volume element
%
%SEE the code comments for a description of the volume structure.

if nargin ~= 2
  error('mrVcoord:  2 arguments required');
end

% Make sure iSize, not vSize, is passed.
%
if prod(size(iSize,2)) ~= 2
  error('mrVcoord:  iSize variable suspicious')
end

if size(inData,2) == 1 % Scalar input, 3d return

% For this logic to work, the list counting must begin
% at zero.  So, we subtract 1 from inData since Matlab
% lists begin with 1.
%
  z = floor( (inData-1) ./ prod(iSize)) + 1;

  xyIndex = mod((inData-1),prod(iSize));
  x = floor(xyIndex ./ iSize(1) ) + 1;
  y = mod(xyIndex,iSize(1)) + 1;
  res = [x,y,z];

elseif size(inData,2) == 3  % 3d input, scalar return

% Here is some code to test the logic:
% The volumes are stored down the column of each image first, as in
%
%   anatomy = zeros(prod(iSize),nFiles);
%   anatomy = reshape(anatomy,1,prod(size(anatomy)));
%

% a = [1 2; 3 4 ; 5 6]
% b = [10 20; 30 40; 50 60 ];
% iSize = size(a)
% test = zeros(prod(iSize),2);
% test(:,1) = a(:)
% test(:,2) = b(:)
% vtest = reshape(test,1,prod(size(test)))
% inData = [3 1 2]

  res = inData(:,2) + (inData(:,1)-1)*iSize(1) + (inData(:,3) - 1)*prod(iSize);

% vtest(res)

else
 error('mrVcoord:  arguments must be in the columns')
end

