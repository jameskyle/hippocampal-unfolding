function [selpts] = mrExtractROIRet (curAnat, selpts)

%    Takes selpts, extracts the relevant ones and returns them.
% Returns both rows of selpts (because some functions care about
% which anatomy images which points came from).

% 7/07/97 Lea updated 5.0
if isempty(selpts)
   disp('No region of interest selected for any anatomy image.');
   return
end

if (~any(selpts(2,:) == curAnat))	% if no region of interest for this anatomy
      disp('No region of interest selected for this anatomy image.');
      selpts = [];
else
   selpts = selpts(:,selpts(2,:) == curAnat);
end


