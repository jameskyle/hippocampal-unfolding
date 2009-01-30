function foundit = check4File(filename)
%foundit = check4File(filename)
%
%Checks the current directory for matlab file:
% <filename>     if there is a '.' in the file name
% <filename>.mat otherwise

%returns 1 (true) if file is found.  
%returns 0 (false) if file is NOT found.

%11/24/96 gmb  wrote the two lines of code.

if findstr(filename,'.') ==[]
  filename = [filename,'.mat'];
end

unixstr = ['test -f ',filename];
foundit = (unix(unixstr)==0);


