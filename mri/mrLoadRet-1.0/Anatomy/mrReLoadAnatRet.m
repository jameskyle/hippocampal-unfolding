function [anat, anatmap, curImage, curSize, curCrop] = mrReLoadAnatRet(curAnat,viewPlane)
% [anat, anatmap, curImage, curSize, curCrop] = mrReLoadAnatRet([curAnat],[viewPlane])
%
%	Loads anatomy images which have been previously saved to disk
% via mrSaveAnat.  It returns curImage, curSize, curCrop, and curDisplayName
% (anatomy) in that order.

% 6/11/96	gmb	Added optional curAnat input
% 9/ 2/96       gmb     Added optional viewPlane input for
%                       flattened data

if nargin==0
	curAnat=1;
end

if nargin==1
  viewPlane='inplane';
end

if strcmp(viewPlane,'inplane')
  load anat
else
  eval(['load Fanat_',viewPlane]);
  curSize = fSize;
end

curImage = anat(curAnat,:);
mrColorBar(0,'off');






