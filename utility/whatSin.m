function whatSin(datName)
%
% whatSin(datName)
%
% Prints a list of the variables in a mat file.
% datName is a string containing the name of the mat file.
% Example:   whatSin('xyz')  or   whatSin('xyz.mat')
% returns the list:   comment  wavelength   xyz  
%
% Note: the mat file must be in the path.
%
% Hagit Hel-Or
% Last Modified: 6/11/96


eval(['load ' datName]);
clear datName
clear ans
who
