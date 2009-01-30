function cwd = changeDir(newDir)
%
%AUTHOR: Wandell
%DATE:   12.05.95
%
%08.20.98
% WP/BW used chdir instead of eval.
%
% In the past, chdir wasn't around...or, we didn't know about it.
% So, we wrote this routine.  It should be toast

disp('Warning: Your code uses ''changeDir''.  You should use ''chdir'' instead.');
chdir(newDir);

return;

eval(['cd ',newDir]);

if nargout > 0
 cwd = cd;
end
