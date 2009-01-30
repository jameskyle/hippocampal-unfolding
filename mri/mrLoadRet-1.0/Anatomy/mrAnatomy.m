function [curImage] = mrAnatomy(curSer,selpts,anat,anatmap,ROI_menu)
%[curImage] = mrAnatomy(curSer,selpts,anat,anatmap,ROI_menu)

%09/17/96  gmb  Wrote it.
%06/19/97  ll,abp -- Updated to 5.0

curImage = anat(anatmap(curSer),:);

if any(selpts)
  pts = selpts(1,selpts(2,:)==anatmap(curSer));
else
  % 06/20/97 Lea Li -- updated to 5.0
  % selpts must equal [] to get here.  
  % Force and assignment of 'pts'.
  pts = [];
end
if strcmp(get(ROI_menu,'Label'),'Hide ROI') & ~isempty(pts)
  curImage(pts)=-2*ones(1,length(pts)); %blue
end

cmap = [gray(128);hsv(128)];	 % The color map 
cmap(129,:) = [0,1,0];	% green
cmap(130,:) = [0,0,1];	% blue
cmap(131,:) = [1,0,0];	% red

colormap(cmap);

%Draw the colorbar.
mrColorBar(NaN,'off');






