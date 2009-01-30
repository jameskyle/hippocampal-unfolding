function s = backSlashes(s)
% s = backSlashes(s) converts all '/' & '\' to '\'
%


slashes = [findstr('/',s) findstr('\',s)];
s(slashes) = '\';