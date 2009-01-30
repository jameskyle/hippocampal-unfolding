function [selpts_left,selpts_right] = ...
    mrProjectROI2Flat(selpts_inplane,curSize)
%
% selpts = mrProjectROI2Flat(selpts_inplane,curSize)
%
%AUTHOR:  Boynton, Wandell
%DATE: Sept. 30
%PURPOSE:
%  Convert the selected points in the inplanes to selected points
% in both the right and left flattened representation.
%

% The selpts for the side we are headed towards doesn't exist,
% or else we wouldn't be here.  So, go create one using the
% selpts_gray information.
%

% 7/09/97 Lea updated to 5.0
if isempty(selpts_inplane)
  selpts_left = [];
  selpts_right = [];
  return
end

disp('Projecting ROI to flattened hemispheres ...');

z = selpts_inplane(2,:)';
xy = mrVcoord(selpts_inplane(1,:)',curSize);
xyz = [xy(:,1:2),z];
xselpts = mrVcoord(xyz,curSize);

side = mrExistSides;

for hemisphere = side
  
  %Load in flattened anatomy in order to get gray2flat
  %and other good stuff in here.
  %
  if (hemisphere == 'l')
    load Fanat_left
  elseif (hemisphere == 'r')
    load Fanat_right
  end

  %look for intersection of xselpts and gray2inplane
  
  selpts_gray = findAll(xselpts',gray2inplane);  

  %create selpts_[side] from selpts_gray and gray2flat

  indx = gray2flat(selpts_gray,:)';
  unit = ones(1,length(indx));

  if (hemisphere == 'l')
    selpts_left = [indx; unit];
  elseif (hemisphere == 'r')
    selpts_right = [indx; unit];
  end
  
end

selpts_left=mrMergeSelpts(selpts_left,[]);
selpts_right=mrMergeSelpts(selpts_right,[]);

