function phase_cmap = mrResetCmap(phase_cmap,curDisplayName,loadRetWin)
% AUTHOR:  Poirson
% DATE:    03.12.97
% PURPOSE: Reset color map for phases data to 'hsv'.
% HISTORY:  
% NOTES:

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

% 
phase_cmap = [gray(128);hsv(128)];
figure(loadRetWin);
colormap(phase_cmap);

return
