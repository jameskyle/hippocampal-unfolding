function [curImage] = mrConPhase (curSer, co, ph, anat, anatmap, curSize,phase_cmap,pWindow, nconnected)
%[curImage] = mrConPhase (curSer, co, ph, anat, anatmap, curSize,phace_cmap,pWindow, [nconnected])
% Superimpose scaled thresholded phases on anatomy.
% Filter based on correlation threshold and connectedness constraint.

% Variable Declarations
thr1 = [];			% Matrix of 1s and 0s.  1 means co > thresh
				% 0 means co <= thresh.  
thr2 = [];                      % threshold by corr and connectedness
mask = ones(3,3);

global slico;

% 7/07/97/ Lea updated to 5.0
if isempty(co)
   disp ('Correlation data is not available.');
   return
end

if (nargin < 9)
  nconnected = 3;   % default
end

thr1 = (co(curSer,:) > get(slico, 'value') & mrGetInpWindow(ph(curSer,:),pWindow));
% thr1 = co(curSer,:) > (get(slico, 'value')); % compare correlation to threshold
thr1 = reshape(thr1,curSize(1),curSize(2));
thr2 = zeros(curSize(1),curSize(2));

for x=2:curSize(1)-1
  for y=2:curSize(2)-1
    if (thr1(x,y) == 0)
      thr2(x,y) = 0;
    else
      neighbors = sum(sum(thr1(x-1:x+1,y-1:y+1) .* mask));
      thr2(x,y) = (neighbors >= nconnected+1); % +1 for the point x,y itself
    end
  end
end

% 7/07/97 Lea updated to 5.0
thr2 = reshape(thr2,1,curSize(1)*curSize(2));
thr2 = 1-thr2;
curImage = ph(curSer,:);
curImage = -round((curImage)*(128/(2*pi)));	%New 0-2*pi 
% curImage = -round((curImage + pi)*(128/(2*pi)));
curImage(find(thr2)) = anat(anatmap(curSer),find(thr2));
colormap([gray(128);hsv(128)]);
mrColorBar(0:45:360);

