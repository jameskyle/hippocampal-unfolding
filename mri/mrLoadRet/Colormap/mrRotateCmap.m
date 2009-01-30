function phase_cmap = mrRotateCmap(phase_cmap,curDisplayName,loadRetWin)
% AUTHOR:  Poirson
% DATE:    03.12.97
% PURPOSE:
%   Rotates colormap with mouse presses.
%   
% HISTORY:  Started with 'mrShiftCmap'
%           03.18.97  gmb  Wrote mrRotateCmap by borrowing from mrvAreaCmap
% NOTES:
%   I tried to set this up as a toggle routine, but I needed
%   to keep track of global settings so I gave up.

% Increment to shift the colormap for each button press
SHIFT = 2;

% Check to see if phases are on display
if ~(strcmp(curDisplayName,'phase') | ...
      strcmp(curDisplayName,'conphase') | ...
      strcmp(curDisplayName,'medphase'))
  disp(' Must be displaying phase data to use this function');
  return
end

if ~exist('loadRetWin')
  loadRetWin = 1;
end

% 7/10/97 Lea updated to 5.0
% To avoid multiple redraws, set(gcf,'sharecolors','off').
% So MATLAB says in 'spincmap'.
figure(loadRetWin);
sh = get(gcf,'sharecolors');
set(gcf,'sharecolors','off')
  
% Load new color map
colormap(phase_cmap);
  
% Rotate, first put up some instructions
disp('Left Button:   Rotate LEFT,');
disp('Middle Button: Rotate RIGHT,');
disp('Right Button:  QUIT');
   
tempColorMap = phase_cmap(129:256,:);

b = 0;
while (b ~= 3)
  [x,y,b] = ginput(1);
  if (b == 1)
    tempColorMap = cmapRotate(tempColorMap,SHIFT,'l');
    phase_cmap(129:256,:) = tempColorMap;
    colormap(phase_cmap);
  elseif (b == 2)
    tempColorMap = cmapRotate(tempColorMap,SHIFT,'r');
    phase_cmap(129:256,:) = tempColorMap;
    colormap(phase_cmap);
  end
end
   
set(gcf,'sharecolors',sh)
return

