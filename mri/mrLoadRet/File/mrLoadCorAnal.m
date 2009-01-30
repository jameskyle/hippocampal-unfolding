function [co, ph, amp, dc] = mrLoadCorAnal(viewPlane)
%[co, ph, amp, dc] = mrLoadCorAnal([viewPlane])
%
%Loads in correlation matrics (co, ph, amp, dc).  
%if viewPlane == 'inplane', CorAnal.mat is loaded
%   divides by dc if it exists
%if viewPlane == 'left' or 'right', FCorAnal_<viewPlane>.mat is
%loaded.

% 9/2/96  gmb  Wrote it.
% 8/6/97  djh  Modified to divide by dc if it exists

if nargin==0
  viewPlane='inplane';
end

disp('loading correlation matrices...');
if strcmp(viewPlane,'inplane')
  load CorAnal
  if exist('dc')
    disp('Dividing by dc to convert to percent signal modulation...');
    amp=100*amp./dc;
  else
    disp('Warning: no dc in CorAnal.mat...');
    disp('You can create one by running createDC');
  end
else
  eval(['load FCorAnal_',viewPlane]);
  if exist('dc')
    disp('Dividing by dc to convert to percent signal modulation...');
    goodvals =find(dc>0);
    amp(goodvals)=100*amp(goodvals)./dc(goodvals);
  else
    disp('Warning: no dc in FCorAnal.mat...');
    %disp('You can create one by running createDC');
    dc = ones(size(amp));
  end
end
disp('done.');


