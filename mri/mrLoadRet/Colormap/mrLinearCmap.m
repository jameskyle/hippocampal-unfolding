function cmap = mrLinearCmap(cmap,curDisplayName,loadRetWin,gamma)
%
% AUTHOR: Baseler, Poirson
% DATE:   2.28.97
% PURPOSE: Correct for the non linear input-output relationship
%	   between colormap entries and colors produced on the
%          the monitor.  This works best for 'hsv' colormaps.
% USAGE:   
% HISTORY:
% INPUTS:  cmap: colormap to be corrected, values between (0-1)
%          gamma: exponent of non-linear input-output
%                 relationship. [DEFAULT = 1.9]

% OUTPUT: cmap: corrected colormap

DEFAULT_GAMMA = 1.9;

if (nargin < 4)
	gamma = DEFAULT_GAMMA;
end
 
% Check to see if phases are on display
if ~(strcmp(curDisplayName,'phase') | ...
      strcmp(curDisplayName,'conphase') | ...
      strcmp(curDisplayName,'medphase'))
  disp(' Must be displaying phase data to use this function');
  return
end

%   
if ~exist('loadRetWin')
  loadRetWin = 1;
end

upperCmap = cmap(129:256,:);
upperCmap = upperCmap .^ (1/gamma);
cmap(129:256,:)=upperCmap;
colormap(cmap);
 
return





