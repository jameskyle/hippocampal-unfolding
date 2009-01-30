function cieXYZ = xyY2XYZ(xyY)
%
%	Convert a xyY to XYZ
%
if size(xyY,1) ~= 3
 error('xyY must be in the columns')
end

Y = xyY(3,:);
X = (xyY(1,:) ./ xyY(2,:)) .* Y;
Z = ((1 - xyY(1,:) - xyY(2,:)) ./ xyY(2,:)) .* Y;
cieXYZ = [X; Y; Z];

