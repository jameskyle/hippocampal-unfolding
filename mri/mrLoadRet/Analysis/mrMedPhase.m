function [curImage] = mrMedPhase (curSer, co, ph, anat, anatmap, curSize,phase_cmap,pWindow, filtsize, nconnected)
%[curImage] = mrMedPhase (curSer, co, ph, anat, anatmap, curSize,phase_cmap,pWindow, filtsize, nconnected)
% Superimpose scaled thresholded phases on anatomy.
% Filter based on correlation threshold and median filter.

% Variable Declarations
thr1 = [];			% Matrix of 1s and 0s.  1 means co > thresh
				% 0 means co <= thresh.  
thr2 = [];                      % threshold by corr and connectedness
mask = ones(3,3);

global slico;

% 7/07/97 Lea updated to 5.0
if isempty(co) 
   disp ('Correlation data is not available.');
   return
end

if (nargin < 9)
  filtsize = 2;   % default
end
if (nargin < 10)
  nconnected = 3;   % default
end

disp('Calculating median filter...');

corrs = reshape(co(curSer,:),curSize(1),curSize(2));
filtcorrs = mrMedianFilter(corrs,filtsize);
filtcorrs = reshape(filtcorrs,1,curSize(1)*curSize(2));

thr1 = (filtcorrs > get(slico, 'value') & mrGetInpWindow(ph(curSer,:),pWindow));
% thr1 = filtcorrs > (get(slico, 'value')); % compare correlation to threshold
thr1 = 1-thr1;

% 7/07/97 Lea updated to 5.0
curImage = ph(curSer,:);
curImage = -round((curImage)*(128/(2*pi)));	%New 0-2*pi 
curImage(find(thr1)) = anat(anatmap(curSer),find(thr1));
colormap([gray(128);hsv(128)]);
mrColorBar(0:45:360);
