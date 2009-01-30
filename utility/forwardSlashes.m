function s = forwardSlashes(s)
% s = forwardSlashes(s) converts all '/' & '\' to '/'
%


slashes = [findstr('/',s) findstr('\',s)];
s(slashes) = '/';