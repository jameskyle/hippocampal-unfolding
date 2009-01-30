function phase_cmap = mrvAreaCmap(phase_cmap,curDisplayName,loadRetWin)
% 
% AUTHOR:  Poirson
% DATE:    03.12.97
% PURPOSE:
%   Help identify visual areas in V-complex.  
%   1) Change color map so that 360 degrees of phase data 
%      are represented by 4 colors.
%   2) Rotate colormap with mouse presses.
%   
% HISTORY:  Started with 'mrShiftCmap'
% NOTES:
%   I tried to set this up as a toggle routine, but I needed
%   to keep track of global settings so I gave up.
% 
% CHANGES:
% 
% Changed color map to 6 values, each spanning 60 deg.  This way
% 180 degrees is taken up by three colors on each hemisphere. -- BW

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

% Construct 4 valued colormap.  This is what we had originally.
% 
% fourColorMap = zeros(128,3);
% fourColorMap(1:32,:)   = ones(32,1) * [1.0, 0.0, 0.0];
% fourColorMap(33:64,:)  = ones(32,1) * [0.0, 1.0, 0.0];
% fourColorMap(65:96,:)  = ones(32,1) * [0.0, 0.0, 1.0];
% fourColorMap(97:128,:) = ones(32,1) * [1.0, 1.0, 0.0];

sixColorMap = zeros(128,3);
sixColorMap(1:21,:)   = ones(21,1) * [1.0, 0.0, 0.0];  %Red
sixColorMap(22:42,:)  = ones(21,1) * [0.0  1.0  0.0];  %Green
sixColorMap(43:64,:)  = ones(22,1) * [1.0, 1.0, 0.0];  %Yellow
sixColorMap(65:86,:) = ones(22,1) *  [0.0, 0.0, 1.0];  %Blue
sixColorMap(87:107,:) = ones(21,1) * [1.0, 0.0, 1.0];  %Magenta
sixColorMap(108:128,:) = ones(21,1) *[0.0, 1.0, 1.0];  %Cyan

phase_cmap(129:256,:)  = sixColorMap;

% 7/09/97 Lea updated to 5.0

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
   
b = 0;
while (b ~= 3)
  [x,y,b] = ginput(1);
  if (b == 1)
    sixColorMap = cmapRotate(sixColorMap,SHIFT,'l');
    phase_cmap(129:256,:) = sixColorMap;
    colormap(phase_cmap);
  elseif (b == 2)
    sixColorMap = cmapRotate(sixColorMap,SHIFT,'r');
    phase_cmap(129:256,:) = sixColorMap;
    colormap(phase_cmap);
  end
end
   
set(gcf,'sharecolors',sh)
return

