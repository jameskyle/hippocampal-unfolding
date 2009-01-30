function files = getFiles(dirName)
% 
% This routine is obsolete and should be replaced by a dir call.
% 
% getFiles(dirName)
%	Returns a matrix containing the names of the files in the 
%	directory specified.  Each row of the resulting matrix is
%	a single name.  Some names may have zeros appended so that
%	all names have the same length.
%
% Rick Anthony
% 4/23/94

% 
disp('Use dir instead of getFiles') 
% 

cwd = pwd;
eval(['cd ' dirName ';']);
list = ls;
eval(['cd ' cwd ';']);
indexes = [0 findstr(list, 10)];
curLen = length(indexes);
maxLen = max(indexes(2:curLen)-indexes(1:curLen-1)-1);
files = zeros(curLen-1, maxLen);
for i = 1:curLen-1,
    temp = list((indexes(i)+1):(indexes(i+1)-1));
    files(i,1:length(temp)) = temp;
end
