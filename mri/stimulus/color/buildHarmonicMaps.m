function [rgbMap,parameters] = ...
    buildHarmonicMaps(deltaLMS,meanLMS,contrastLMS, ...
    mpData,mapFreq,mapPh, ...
    lms2rgb,invGamma)
%
%AUTHOR: Wandell, Baseler
%DATE:   11.1.96
%PURPOSE:
%  Create a set of color maps for use in displaying harmonic
%functions with a particular mean and color direction.  The
%contrast, frequency and phase of the stimulus vary for each colormap
%
%ARGUMENTS:
% deltaLMS:  3 x 1 vector describing the LMS color diretion
% meanLMS:       3 x 1 vector desribing the LMS mean 
% contrastLMS:  Vector of contrast values applied to deltaLMS
% mpData:    If a 3 vector, then [mpSize,start,stop], which
%     desribe the number of rows in the color map (mpSize) and the
%     start and stop locations where the data are entered.
%     
%            If a number, then we assume that we fill up the
%     whole color map (i.e., start = 1, mpSize = stop = mpData)
%     
% mapFreq:   Vector of frequency values
% mapPh:     Vector of phase values
% lms2rgb:   3x3 matrix to mape a column vector, lms, into a
%     column vector, rgb: rgb = lms2rgb * lms  (default:
%     Smith-Pokorny cones and SanyoLCD).
% invGamma:  Inverse Gamma for the display device (default SanyoLCDGam)
%     
%RETURNS:
%
% rgbMap:  A matrix containing a color map for each of the
%          parameter values.  This matrix has mpSize rows and
%          3 times the number of parameter combinations as columns.
% parameters:  A matrix whose rows contain the (contrast, freq,
%          phase) values for each map

% deltaLMS = [1 0 0]';
% meanLMS = [.5 .55 .2]'
% mpData =   [ 128 ];
% contrastLMS = [ .01 .02 .04]
% mapFreq = 1;
% mapPh = [ 0 pi];

%  Handle the input argument defaults
%          
if nargin < 7
  disp('Using Smith-Pokorny cones (ncones) and SanyoLCD ')
  load ncones
  load sanyoLCD
  lms2rgb = inv(spCones'*sanyoLCD);
  load sanyoLCDGam
  invGamma = sanyoLCDGamInv;
elseif nargin < 8
  disp('Using SanyoLCD Gamma')
  load sanyoLCDGam
  invGamma = sanyoLCDGamInv;
end

if length(mpData) == 3
 mpSize = mpData(1); start = mpData(2); stop = mpData(3);
elseif length(mpData) == 1
 start = 1; stop = mpData; mpSize = stop;
else
  mpData
  error('mpData must have 1 or 3 entries')
end

% Compute the combinations of contrast, frequency and phase
% values of the harmonic maps
%
[c f p] = meshgrid(contrastLMS,mapFreq,mapPh);
c = c(:); f = f(:); p = p(:);
parameters = [c f p];

nMaps = size(parameters,1);
nValues = stop - start + 1;
lmsMap = zeros(nValues,3);
rgbMap = zeros(mpSize,nMaps*3);
lms = zeros(1,nValues);

for i = 1:size(parameters,1)
  harmonic = ( c(i)* sin( (2*pi*f(i)*[1:nValues]/nValues) + p(i)) );
  lmsMap =  ...
      (meanLMS(:,ones(nValues,1)) + diag(deltaLMS)*harmonic([1 1 1],:))';

  if checkRange(lmsMap(:),0,1) ~= 0
    [c(i), f(i), p(i)]
    error('lmsMap out of range')
  end

%  plot(lmsMap)
%  t = sprintf('Map %d: c = %.4f f = %.2f p =%.2f', ...
%      i,parameters(i,1),parameters(i,2),parameters(i,3));
%  set(gca,'ylim',[0 .1],'xlim',[1 128])
%  title(t), pause(2)

% Convert the linear map to frame buffer map using the invGamma data.
% Place the values directly into the columns of the returned matrix
%
  linRGBMap = (lms2rgb*lmsMap')';
  rgbMapCol = (i-1)*3 + 1;
  rgbMap(start:stop,rgbMapCol:rgbMapCol+2) = ...
      rgb2dac([linRGBMap(:,1), linRGBMap(:,2), linRGBMap(:,3)],invGamma);

end

rgbMap = macMap(rgbMap);

return

% Check the returned rgbMap values
% 
nMaps = size(parameters,1)
for i = 1:nMaps
  i
  rgbMapCol = (i-1)*3 + 1; 
  t = sprintf('Map %d: c = %.4f f = %.2f p =%.2f', ...
      i,parameters(i,1),parameters(i,2),parameters(i,3));
  plot(rgbMap(:, rgbMapCol:(rgbMapCol+2)))
  title(t)
  set(gca,'ylim',[0 1],'xlim',[1 128])
  pause(3)
end
