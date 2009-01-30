function command(s)
% runs the command specified by the string s
%

if strcmp(computer,'PCWIN')
   % work-around the stupic matlab bug that won't
   % allow dos commands when the current dir is unix
   curDir = pwd;
   cd('c:');  
   if ~strcmp(s(1:min(3,length(s))), 'rsh')
      % most dos commands require backslashes
      dos(backSlashes(s));
   else
      % special case for remote shell call- use forward slashes
      dos(forwardSlashes(s));
   end
   cd(curDir);
else
	unix(forwardSlashes(s));
end
