function [merged, mergedMap] = ...
    wPhMap(anatimage,corimage,phimage,imSize,pWindow,imMap, ...
           sliders, ...
           support,sd,exponent);
%
% AUTHORS:   Brian Wandell, Heidi Baseler
% DATE:      11.6.97
% PURPOSE:   To make flattened phase maps, weighted by
% correlation values, superimposed on gray scale flattened anatomy
%
% INPUTS:
% anatimage:    matlab data describing the anatomy.  Forced to
%               1:64 as mrLoadRet
% corimage:     correlation data.  Between 0 and 1
% phimage:      phase data.  Range is in ... radians
%
% RETURNS:
% newimage:     tiff image combining all the above information

% DEBUGGING:
%
%
% curSer = 16;
% anatimage = anat(anatmap(curSer),:);
% corimage = co(curSer,:);
% phimage = ph(curSer,:);
% imSize = curSize;
% pWindow = pWindow
% imMap = phase_cmap;
% sliders.co = slico;
% sliders.max = slimax;
% sliders.min = slimin;
% support = [], sd = [], exponent = [], semiSaturation = [];

% wPhMap(anatimage,corimage,phimage,imSize,pWindow,imMap,sliders,[],[],[]);

nGrayLevels = 256;
phaseMap = imMap(129:256,:);

if (size(imMap,1) < 256)
  fprintf('Size of input map:  %f\n',size(imMap));
  error('Expecting a color map with 256. 1:128 gray, 129:256 phase')
end 

if nargin < 6
  error('wPhMap:  requires at least 6 arguments')
end

if (~exist('support')), support = [];  end
if (~exist('sd') ), sd = []; end
if (~exist('exponent')), exponent = []; end
if (~exist('semiSaturation')), semiSaturation = []; end

if (isempty(support)) support = 11;  end
if (isempty(sd)), sd = 2; end
if (isempty(exponent)), exponent = 4; end
if (isempty(semiSaturation)), semiSaturation = get(sliders.co,'value'); end

% Get rid of phases outside the pWindow
% 
badValues = ~(corimage > 0 & mrGetInpWindow(phimage,pWindow)); 

% Also remove the NaNs
% 
badValues = badValues | isnan(phimage);

% Set the phase values to zero if they are in badValues
% 
phimage(badValues) = zeros(size(phimage(badValues)));

% Scale the good values to run between 1 and 128
% 
nPhaseLevels = size(phaseMap,1);
phimage = round(scale(phimage,1,nPhaseLevels));

% foo = phimage;
% l = corimage < .35;
% foo(l) = 1;
% image(reshape(foo,imSize)); colormap([0 0 0;phaseMap]);

% This is basically the code from
% myShowImage(anatimage,imSize).  It should be encapsulated
% somewhere. 

anatMin = max(anatimage)*get(sliders.min,'value');
anatMax = max(anatimage)*get(sliders.max,'value');

low = (anatimage < anatMin);
anatimage(low) = anatMin*ones(1,sum(low));
anatimage(anatimage>anatMax) = anatMax*ones(1,sum(anatimage>anatMax));
anatimage = round(scale(anatimage,1,nGrayLevels));

% Build a gray map for later use
% 
grayMap = gray(nGrayLevels);

% Check flattened anatomy map
% figure(3), clf
% colormap(grayMap)
% image(reshape(anatimage,imSize)); axis image

% Now, blur the (r,g,b) image associated with the phase values
% 
kernel = mkGaussKernel(support,sd);
blurredPhaseMap = zeros(prod(imSize),3);
for ii=1:3 
  tmpImage = reshape(phaseMap(phimage(:),ii),imSize(1),imSize(2));
  tmpImage = conv2(tmpImage,kernel,'same');
  blurredPhaseMap(:,ii) = tmpImage(:);
end

% Quantize the correlation coefficient values so that we 
% can use them as indices into the wgts
% 
qCurCo = round(scale(corimage,1,100));

% Set up the function for computing the weight given to the
% anatomy and the phase data
% 
cofunc = [.01:.01:1];
wgts = ...
    (cofunc .^exponent) ./ ((cofunc .^exponent) + semiSaturation.^exponent);
% 
% plot(cofunc,wgts)

% Compute the mixture of the (r,g,b) values of the phase map and
% the (g,g,g) values of the anatomicals.  The relative contribution
% for the mixture decided by the correlation weights.
% 
merged = zeros(prod(imSize),3);
for ii=1:prod(imSize)
 merged(ii,:) = blurredPhaseMap(ii,:)*wgts(qCurCo(ii)) + ...
      grayMap(anatimage(ii),:)*(1 - wgts(qCurCo(ii)));
end

fprintf('Running rgb2ind to create 8 bit merged image\n'); 
[merged,mergedMap] = rgb2ind(merged(:,1),merged(:,2),merged(:,3),256);
merged = reshape(merged,imSize);

% 
colormap(mergedMap);

% Drawing is done in RefreshScreen
% 
fprintf('Done.\n');

return;

