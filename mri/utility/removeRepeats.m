function listOut = removeRepeats(listIn)
% function listOut = removeRepeats(listIn)
%
% 08.01.98 SJC
%
% PURPOSE:	removes any repeated entries in listIn, returns
%		the new list with no repeats in listOut
%
% ARGUMENTS:	listIn:		Input vector or matrix.
%
% RETURNS:	listOut:	Output vector
%

fprintf('WARNING: Change call to "removeRepeats" to "unique"!\n');

isDone = 0;

ii = 1;

listOut = listIn(:);

while ~isDone
  % Find all repeats of the current list element
  %
  repeats = find(listOut == listOut(ii));

  % Eliminate current list element from repeats list
  %
  repeats(1) = [];
  
  % Eliminate repeats from list
  %
  listOut(repeats) = [];

  ii = ii + 1;

  if (ii > length(listOut))
    isDone = 1;
  end
end

return
