function xy = chromaticity( XYZ )
%
%       chromCoords = chromaticity( colorData )
%
% PURPOSE: 
%	Calculate the chromaticity coordinates from the data in a matrix,
%	say of XYZ values.
%
%	The color data should be in the columns, i.e. there must be 3 rows.
%
%	The chromaticity coordinates are in the columns of the returned matrix.
%
if size(XYZ,1) ~= 3
  error('The 3d color data should be in the columns of the matrix')
end

ncols = size(XYZ,2);
xy = zeros(2,ncols);

s = sum(XYZ);

xy(1,:) = XYZ(1,:) ./ s;

xy(2,:) = XYZ(2,:) ./ s;

