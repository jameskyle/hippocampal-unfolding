function foundit = check4File(filename)
% 
% foundit = check4File(filename)
%
% AUTHOR:  Boynton
% PURPOSE:
%  Check for a file with a .mat extension in the current working
%  directory, or relative to the current directory.
%  This is a special case of exist.
%  
% Modified 08.20.98 WP/BW
%  
%  We used the Matlab exist function here, so we don't need a
%  unix call.  In other ways, we left it compatible with the
%  old check4file.  We wrote it in a way to try  to prevent Matlab
%  for checking for other instances of the file in other
%  directories along the path, the default Matlab behavior.
%    
%    BUGS:  This routine is only checking for files with a .mat
%    extension. It should be called something else, like
%       check4MatFile.  Probably, it shouldn't exist at all, and
%    we should only use exist and force the code to be explicit
%    about the file name and path.
%    

% Add the .mat extension if it isn't passed in
%    
if isempty(findstr(filename,'.'))
  filename = [filename,'.mat'];
end

%  If the filename passed in has a / or a \ in it, leave things alone.
%  Otherwise, preappend './'.  This is to stop Matlab
%  from finding files with the same name elsewhere on the path. 
%  
if isempty(findstr(filename,'/')) & isempty(findstr(filename,'\'))
   filename = ['./' filename];
end

%  Specify the full path so that we will only find one in the
%  current directory, nowhere else in the path
%    
if exist(filename,'file')
  foundit = 1;
else
  foundit = 0;
end

return;

%  
%    This is the old code
%    
if isempty(findstr(filename,'.'))
  filename = [filename,'.mat'];
end

unixstr = ['test -f ',filename];
foundit = (unix(unixstr)==0);


