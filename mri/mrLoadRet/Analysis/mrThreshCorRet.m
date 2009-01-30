function [curImage] = mrThreshCorRet(curSer,co,ph,anat,anatmap,pWindow,fixedCorCmapRange)
%
% [curImage] = ...
%    mrThreshCorRet(curSer,co,ph,anat,anatmap,pWindow,fixedCorCmapRange)
%
% edited on 6/5/95 by gmb:  Added pWindow
% Modified 03.20.97 ABP/BW  Added fixedCorCmapRange.

% Variable Declarations
thr = [];			% Matrix of 1s and 0s.  1 means co > thresh
				% 0 means co <= thresh.  
global slico;

if isempty(co)
   disp ('Correlation data is not available.');
   return
end

scalefac=180/pi;
curImage = anat(anatmap(curSer),:);
thr = (co(curSer,:) > get(slico, 'value') & ...
    mrGetInpWindow(ph(curSer,:),pWindow));   

if sum(thr>0)
  colormap(mrRedGreenCmap);

  %Set up the correlation data for the color overlay.  Modified 03.20.97/BW/ABP
  %
  if (isempty(fixedCorCmapRange))
    m1 = min(co(curSer,thr));
    m2 = max(co(curSer,thr));
  else
    m1 = fixedCorCmapRange(1);
    m2 = fixedCorCmapRange(2);
  end
  
  curImage(thr) = -1*(scale(co(curSer,thr),1,128,m1,m2));
  x_axis = linspace(m1,m2,10);
  mag=10^floor(log10(abs(mean(x_axis))));
  
  % 7/01/97 Lea updated to 5.0
  mag = mag/10;
  
%  x_axis = round(x_axis/mag)*mag;
  
  mrColorBar(x_axis);
end





