function str = cell2str(theCell)
%str = cell2str(theCell)
%
%converts cell array of strings to a string matrix.
%Why isn't this a regular MATLAB function?

%4/10/98  gmb   Wrote it, but wasn't excited about it.

nCells = size(theCell,2);
str = '';

tmpStruct = cell2struct(theCell,'stupid');

for cellNum = 1:nCells
  str = strvcat(str,tmpStruct(cellNum).stupid);
end



