function num = cell2num(theCell)
%num = cell2num(theCell)
%
%converts cell array of strings to a matrix.
%Non-numerical entries are returned as NaN's.
%Why isn't this a regular MATLAB function?

%4/11/98  gmb   Wrote it, but wasn't excited about it.

theChar = char(theCell);

for cellNum = 1:size(theChar,1)
  tmp = str2num(theChar(cellNum,:));
  if isempty(tmp)
    tmp = NaN;
  end
  num(cellNum) = tmp;
end



