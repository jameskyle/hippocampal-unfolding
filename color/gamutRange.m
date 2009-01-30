function newColorDir = gamutRange(meanField,colorDir)
%
%AUTHOR:  Wandell
%DATE:    04.15.96
%PURPOSE:
%  Find the highest absolute contrast level of colorDir that can be added
% to the meanField and still be within range (unit cube) for the rgb values.
%
% The assumptions of this calculation are that
%   ** The rgbs range from [0 1]
%   ** Everything in sight is linear 
% 
% The idea is that over the range m in [-1 1], for each of r,g,b
%
%    m*colorDir + meanField <= 1, and
%
%    m*colorDir + meanField >= 0
%
% So, for each channel we find the limiting values that sets one
% channel to zero or one.
%
% Then, we return the scaled colorDir vector such that it will be
% within gamut for m in the range [-1 1].
%

if min(meanField) <= 0
 min(meanField)
 error('Mean field parameter must be all positive')
end

if max(meanField) >= 1
 max(meanField)
 error('Mean field parameter must be less than 1.0')
end

% p*colorDir must be less than the meanField value
%
zeroRatios = -meanField ./ colorDir
colorDir .* zeroRatios + meanField

% p*colorDir must be less than 1 - meanField value
%
oneRatios = (1 - meanField) ./ colorDir
colorDir .* oneRatios + meanField

% Now, find the max ratio between all of these 
%
absRatios = abs([zeroRatios; oneRatios])
[m i] = min(absRatios)
newColorDir = colorDir*absRatios(i)

return

% To check, it should be the case that the max or min of these two
% vectors should be 1 or 0
%
meanField + newColorDir

meanField - newColorDir

max(meanField + newColorDir)
min(meanField + newColorDir)
max(meanField - newColorDir)
min(meanField - newColorDir)

%%%% end

