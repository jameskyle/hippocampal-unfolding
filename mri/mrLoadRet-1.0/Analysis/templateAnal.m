function [varExp, ph, amp, dc] = templateAnal(dat,freq,ltrend,template)
% 
% AUTHOR:  Poirson, Wandell
% DATE:    12.19.97
% PURPOSE:
%   Analyze the time series (in dat) with respect to a timeseries
% template (in template).  This template should have a length
% equal to one of the cycles of the stimulus.  When freq is
% specified, there is no need for template and this routine
% simply calls mrFTCorSeries.  In this way we are backwards
% compatible for the case when the template is a harmonic.
% 
% When templateAnaly(dat,[],ltrend,template) is called, then
% template must exist and the current routine is invoked.  If
% freq is not empty, then the data are routed through mrFTCorSeries.
% 

% dat = rand(72,10000);
% ltrend = []
% freq = [];
% template = [1 1 1 0 0 0];

if (~isempty(freq))
  disp('templateAnal:  Calling mrFTCorSeries');
  [varExp,ph, amp, dc] = mrFTCorSeries(dat,freq,ltrend);
  return;
end

if nargin < 4
  error('Bad arguments to templateAnal');
  return;
end
 
if isempty(ltrend), ltrend = 'y'; end
if isempty(template)
  error('templateAnal:  No template specified and no default available'); 
  return; 
else
  nTemplate = length(template);
  template = reshape(template,nTemplate,1);
end

% Main routine for local processing.
% 
nTsamples = size(dat,1);
nPixels = size(dat,2);
nCycles = nTsamples/nTemplate;

if rem(nTsamples,nTemplate) ~= 0
  error('Template length must divide evenly into timeseries length')
  return;
end

% Compute and then remove the mean for the input data
% 
dc = mean(dat);
dat = detrend(dat,0);

% Remove the linear trend, if asked.
% 
if (ltrend(1) == 'y'),   dat = detrend(dat); end

template = unitLength(template,'c');

% Next we build the convolution matrix for the template
% 
templateMatrix = zeros(nTemplate,nTemplate);
for ii = [1:nTemplate]-1
  templateMatrix(ii+1,:) =  vecRotate(template,ii,'r')';
end
% colormap(gray(32)); imagesc(templateMatrix);

% Now, we have data with the mean and linear trend removed.
% We begin our own analyses.
% 
% First, take the individual time series and put them each into a
% matrix where one cycle is in a single column.  Different pixels
% are placed in their own matrices.
% 
blockDat = reshape(dat,nTemplate,nCycles,nPixels);

% Calculate the mean amplitude and phase equivalent for each pixel
% 
resp = ones(1,nPixels)*NaN;
for ii=1:nPixels

  % tmp dim is nTemplate (each possible phase position) by nCycles
  % 
  tmp = templateMatrix*blockDat(:,:,ii);
  [pixAmp, pixPh] = max(tmp);
  pixResp = pixAmp .* exp( (- sqrt(-1))* (2*pi*( pixPh ./ nTemplate)) );
  resp(ii) = mean(pixResp);

  % We could compute a std dev at this point by taking the svd of
  % the complex numbers to determine the best ellipsoid through the
  % cloud.
  % 

end
amp = abs(resp);
ph  = phase(resp)*180/pi;

