function [curImage] = mrMedCor (curSer, co, ph, anat, anatmap, curSize,pWindow, filtsize, nconnected)
% mrMedCor(curSer, co, ph, anat, anatmap, curSize, pWindow,[filtsize],[nconnected]);
%
% Superimpose scaled thresholded correlations on anatomy.
% Filter based on correlation threshold, phase window, and median filter.
% NOTE: there _must_ be a more elegant way of computing this.

% Variable Declarations
thr1 = [];			% Matrix of 1s and 0s.  1 means co > thresh
				% 0 means co <= thresh.  
thr2 = [];                      % threshold by corr and connectedness
mask = ones(3,3);

global slico

if isempty(co)
   disp ('Correlation data is not available.');
   return
end
if (nargin < 8)
  filtsize = 2;   % default
end
if (nargin < 9)
  nconnected = 3;   % default
end

disp('Calculating median filter...');

phstart = pWindow(1);
phend = pWindow(2);
if (phstart > phend)
  phstart2 = 0;
  phend2 = phend;
  phend = 3.6;
else
  phstart2 = 0;
  phend2 = 0;
end

corrs = reshape(co(curSer,:),curSize(1),curSize(2));
filtcorrs = mrMedianFilter(corrs,filtsize);
filtcorrs = reshape(filtcorrs,1,curSize(1)*curSize(2));

thr1 = filtcorrs > (get(slico, 'value')); % compare correlation to threshold

thr3 = (ph(curSer,:) > phstart) & (ph(curSer,:) < phend);
thr4 = (ph(curSer,:) > phstart2) & (ph(curSer,:) < phend2);
thr = thr1 & (thr3 | thr4);

curImage = anat(anatmap(curSer),:);
mymin = min(co(curSer,thr));
mymax = max(co(curSer,thr));
range = mymax-mymin;
disp(sprintf('max = %f, min = %f, range = %f',mymax, mymin, range));
curImage(thr) = -1*(scale(co(curSer,thr),1,128));
colormap(mrRedGreenCmap);
mrColorBar(linspace(0,1,11));
