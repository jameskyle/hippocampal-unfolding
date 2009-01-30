function foundit = check4File(filename)
% 
%foundit = check4File(filename)
%
%    This is the old code
%    
if isempty(findstr(filename,'.'))
  filename = [filename,'.mat'];
end

unixstr = ['test -f ',filename];
foundit = (unix(unixstr)==0);

