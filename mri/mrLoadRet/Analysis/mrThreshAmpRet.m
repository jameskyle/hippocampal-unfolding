function [curImage] = mrThreshAmpRet(curSer, co, ph, amp, anat, anatmap, pWindow)
% [curImage] = mrThreshAmpRet (curSer, co, ph, anat, size, pWindow)

% Variable Declarations
thr = [];			% Matrix of 1s and 0s.  1 means co > thresh
				% 0 means co <= thresh.  
				
% 9/6/96  gmb      Created mrThreshAmpRet from mrThreshCorRet
global slico;

% 6/30/97 Lea updated to 5.0
if isempty(co)
   disp ('Correlation data is not available.');
   return
end

scalefac=180/pi;

thr = (co(curSer,:) > get(slico, 'value') & mrGetInpWindow(ph(curSer,:),pWindow));   
curImage = anat(anatmap(curSer),:);

%Determine the scale for the colormap
curImage(thr) = -1*(scale(amp(curSer,thr),1,128));
colormap(mrRedGreenCmap);

%Draw the colorbar.
x_axis = 0:10:max(amp(curSer,:));
mrColorBar(x_axis);
