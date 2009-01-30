function [curImage, curDisplayName] = ...
    mrThreshPhRet (curSer, co, ph, anat,anatmap,phase_cmap,pWindow)
%
% [curImage, curDisplayName ] = ...
%    mrThreshPhRet(curSer, co, ph, anat, curSize,phase_cmap,[pWindow])
%
% PURPOSE:
%   Compute an image whose pixel values show the best phase angle of
%   the time series at each image point.
%   
%
% AUTHOR:  Engel
%
%

% Variable Declarations
resp = [];			% User's response to query 0=cor, 1=ROI
thr = [];			% Vector of 1s and 0s.  1 means co > thresh
				% 0 means co <= thresh.  

%Edited 6/5/95 by gmb: added pWindow option

global slico;
global slimin slimax;


% Check for pWindow entry
if ~exist('pWindow')
	pWindow=[0,360];
end

% 7/02/97 Lea updated to 5.0
if isempty(co)
   disp ('Correlation data is not available.');
   return
end

curImage = ph(curSer,:);
curImage = -round((curImage)*(128/(2*pi)))-1;	%New 0-2*pi 

thr = ~(co(curSer,:) > get(slico, 'value') & mrGetInpWindow(ph(curSer,:),pWindow));  

thr = thr | isnan(ph(curSer,:));
curImage(thr) = anat(anatmap(curSer),thr);

colormap(phase_cmap);

%Draw the colorbar
mrColorBar(0:45:360);

return;
