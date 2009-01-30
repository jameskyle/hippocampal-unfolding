function phase_cmap = mrDoubleWrap(phase_cmap,curDisplayName,loadRetWin,symmetric)
% AUTHOR:  Baseler
% DATE:   2/26/97 
% PURPOSE: 
%  Function to change the phase colormap in mrLoadRet 
%  so that 180 deg from one hemifield maps onto a full
%  hsv colormap (instead of just half of it).
% HISTORY:  2/27/97 gmb --  Turned it into a function and added it to mrLoadRet
%           03.12.97 ABP -- Check that phase data is being displayed
%           03.20.97 ABP -- Added 'symmetric' switch which means cmap is symmetric
%                           about 180 degrees.

% Check to see if phases are on display
if ~(strcmp(curDisplayName,'phase') | ...
      strcmp(curDisplayName,'conphase') | ...
      strcmp(curDisplayName,'medphase'))
  disp(' Must be displaying phase data to use this function');
  return
end

if ~exist('phase_cmap')
  phase_cmap = colormap;
end

if ~exist('loadRetWin')
  loadRetWin = 1;
end

% First part of the map is always the same
phase_cmap(129:129+63,:) = hsv(64);

if (symmetric == 0)
	phase_cmap(129+64:256,:) = hsv(64);
elseif (symmetric == 1)
	phase_cmap(129+64:256,:) = flipud(hsv(64));
end

figure(loadRetWin);
colormap(phase_cmap);

return
