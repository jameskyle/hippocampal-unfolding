function dirList = FindDirectories
% function dirList = FindDirectories
%
% 07.08.98 BW, SJC
% PURPOSE: Find all the subdirectories in the current directory
% ARGUMENTS: None
% RETURNS:   dirList, a string containing all the existing
%            subdirectories
%

ls -F;
fileList = ans;

% Find all line breaks in the list of files
breaks = find(double(fileList) == 10);

% Directories all end with a '/'
dirEnds = find(fileList(breaks-1) == '/');

numOfDirs = length(dirEnds);

dirList = '';

% Extract directory names from the list of files
for ii = 1:numOfDirs
  
  % jj is the index of the beginning of a directory name
  if (dirEnds(ii)>1)
    jj = breaks(dirEnds(ii)-1)+1;
  else
    jj = 1;
  end
  
  dirList = [dirList fileList(jj:breaks(dirEnds(ii)))];
end




