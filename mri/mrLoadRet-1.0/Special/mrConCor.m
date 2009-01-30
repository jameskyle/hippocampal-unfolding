function [curImage] = mrConCor (curSer, co, ph, anat,anatmap, curSize,pWindow,nconnected)
%[curImage] = mrConCor (curSer, co, ph, anat,anatmap,  curSize,pWindow,nconnected)
%
% Superimpose scaled thresholded correlations on anatomy.
% Filter based on correlation threshold, phase window, and
% connectedness constraint.
%

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

if (nargin < 8)
  nconnected = 3;   % default
end

thr1 = (co(curSer,:) > get(slico, 'value') & mrGetInpWindow(ph(curSer,:),pWindow));   


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

thr2 = reshape(thr2,1,curSize(1)*curSize(2));

% 7/07/97 Lea updated to 5.0
curImage = anat(anatmap(curSer),:);
mymin = min(co(curSer,find(thr2)));
mymax = max(co(curSer,find(thr2)));
range = mymax-mymin;
disp(sprintf('max = %5.2f, min = %5.2f, range = %5.2f',mymax, mymin, range));

% 7/07/97 Lea updated to 5.0
curImage(find(thr2)) = -1*(scale(co(curSer,find(thr2)),1,128));
colormap(mrRedGreenCmap);
mrColorBar(linspace(0,1,11));
