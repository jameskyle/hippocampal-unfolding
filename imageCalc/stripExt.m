function result = stripExt(fileName)
% stripExt(filename)
%	Throws away everything after the first '.' character found.
%
% Rick Anthony
% 4/23/94

pt = findstr(fileName, '.');
result = fileName(1:pt(1)-1);
