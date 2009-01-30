%
% function gLocsFunc = mrGray2Func(gLocs3d,rotM,transV,scaleF)
%
%AUTHOR: Boynton, Wandell, Engel
%DATE:
%
%PURPOSE:
% Return the integer voxel value in the volume of functional data
% [iSize(1) iSize(2) nPlanes] of each gray-matter location (gLocs3d).
% 
% The rotation, translation and scale factor are determined using
% mrAlign
%

function gLocsFunc = mrGray2Func(gLocs3d,rotM,transV,scaleF)

% mrAlign writes out the translation and rotation as if we are
% converting from functional to volume.
% Here, use the inverse direction, namely from volume to functional.
%
rotM = inv(rotM);
transV = -transV;

%Convert gLocs3d locations in pixels to millimeters within the inplanes
%
nugLocs3d = gLocs3d'./(ones(size(gLocs3d,1),1)*(scaleF(2,:)))';

%%Translate and rotate
%
nugLocs3d = nugLocs3d+(transV'*ones(1,length(nugLocs3d)));
nugLocs3d = (rotM*nugLocs3d)';

%Convert back from millimeters
%

gLocsFunc = nugLocs3d.*(ones(size(gLocs3d,1),1)*scaleF(1,:));

gLocsFunc = round(gLocsFunc);
