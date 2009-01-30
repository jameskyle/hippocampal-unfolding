function [curImage] = mrThreshMapRet(curSer, co, ph, map, anat, anatmap, pWindow)
% [curImage] = mrThreshMapRet (curSer, map, ph, anat, anatmap, pWindow)

% 10/1/9  gmb Wrote it.

global slico;

curImage = anat(anatmap(curSer),:);
% 7/02/97 Lea updated to 5.0
if isempty(map)
   disp ('Parameter map is not available.');
   return
end

scalefac=180/pi;
thr = (co(curSer,:) > get(slico, 'value') & mrGetInpWindow(ph(curSer,:),pWindow));   
curImage(thr) = -1*(scale(map(curSer,thr),1,128));

%Draw the colorbar.
x_axis = linspace(min(map(curSer,thr)),max(map(curSer,thr)),10);
mag=10^floor(log10(max(x_axis)-min(x_axis)))/2;
x_axis = round(x_axis/mag)*mag;

mrColorBar(x_axis);







