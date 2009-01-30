function [cutoff, curImage] = mrSetSlicoPerc(curSer, co, perc)
% Set slico so that the pixels with correlations in the top perc percent
% are on.
% Note: if used with a median or connectedness filter, the actual percentage
% will of course be lower.
% jmz 10/27/95

% MMZ 6/10/03 isempty bug

global slico;

%if (co == [])
if (isempty(co))
   disp ('Correlation data is not available.');
   return
end

if (nargin < 3)
  perc = 10;  % default
end

sortedco = sort(co(curSer,:));
cutoff = sortedco(ceil((1-perc/100)*length(sortedco)));
disp(sprintf('Percent is %f, cutoff is %f.  Setting slider.',perc,cutoff));

set(slico,'value',cutoff');

