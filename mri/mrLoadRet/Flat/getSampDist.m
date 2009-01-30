function sampDist = getSampDist(unfdir)
%
%   sampDist = getSampDist(unfdir)
%
%AUTHOR:  Boynton
%PURPOSE:
%  Figure out the sampDist parameter associated with
% a unfolding directory set of files
%
%DATE: 8.14.96
%
%ARGUMENTS
%
%RETURNS
%

cmd = ['ls ',unfdir, 'interp*'];

[err fname] = unix(cmd);

if err == 0,   
  sampDist = fname((length(unfdir)+ 7):(length(unfdir)+9));
else
  error('Problem reading interp file for sampDist')
end
