function [selpts]=mrClearROI(selpts,slices,curAnat)
%[selpts]=mrClearROI(selpts,slices,curAnat)
% Clears the ROI in the slices defined by the variable 'slices'
% Re-displays the anatomy only if curDisplayName = 'ROI'

% 6/11/96	gmb	Wrote it.
% 9/16/96       gmb     Removed image refreshing code.
%                       RefreshScreen should be called after 
%                       execution of this function.

if isempty(selpts)
  return
end

if isnan(slices)
  slices = [min(selpts(2,:)):max(selpts(2,:))];
end

refreshflag=0;
for slice=slices
  if size(selpts,2)>0
    pts=(selpts(2,:)==slice);
    if sum(pts)>0
      selpts = selpts(:,~pts);
      if (slice==curAnat)
	refreshflag=1;
      end
    end
  end
end




