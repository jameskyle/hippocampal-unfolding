function selpts_inplane = mrProjectROI2Inp(selpts_left,selpts_right)
%
% function selpts_inplane = mrProjectROI2Inp(selpts_left,selpts_right)
%

load anat

if ~exist('side')
  side = 'lr';
end

selpts_inplane = [];

% 7/09/97 Lea updated to 5.0
for hemisphere = side
  if ( (hemisphere == 'l' & ~isempty(selpts_left)) | ...
       (hemisphere == 'r' & ~isempty(selpts_right)) )
   disp('Projecting ROI to inplanes ...');
   %Load in flattened anatomy in order to get gray2flat
   %and other good stuff in here.
   %
   if (hemisphere == 'l')
     load Fanat_left
     xselpts = selpts_left(1,:)';
   elseif (hemisphere == 'r')
     load Fanat_right
     xselpts = selpts_right(1,:)';
   end
   
   %look for intersection of xselpts and gray2inplane   
   selpts_gray = findAll(xselpts',gray2flat);     
   
   %create selpts_inplane from selpts_gray and gray2flat
   indx = gray2inplane(selpts_gray,:);
   
   [xyz]= mrVcoord(indx,curSize);
   
   onez = ones(size(xyz,1),1);
   
   selpts_inplane = [selpts_inplane, ...
	   [mrVcoord([xyz(:,1:2),onez],curSize),xyz(:,3)]'];
 end
end 					%brainSide loop

%remove duplicates

selpts_inplane = mrMergeSelpts(selpts_inplane,[]);
  
  



