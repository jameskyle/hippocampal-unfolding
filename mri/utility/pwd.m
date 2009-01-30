function wd = pwd

%   PWD  displays the current working directory.
%
%   S = PWD returns the current directory in the string S.
%
%   See also CD.
%
% dbr 1/20/99 Added local feature to strip '/tmp_mnt' HP-UX automount
%             artifact from file names.
% btb 5/3/99 Replace backslashes with forward slashes


wd = cd;
if length(wd) > 7
	if strcmp('/tmp_mnt', wd(1:8)),	wd = wd(9:length(wd)); end
end

% Replace backslashes with forward slashes (if any)
backslashes = find(wd == '\');
wd(backslashes) = '/';

