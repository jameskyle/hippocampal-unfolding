function [res, nReplaced] = replaceNaN(in,newValue)
%
%   [res, nReplaced] = replaceNaN(in,newValue)
%
%AUTHOR:  Wandell
%DATE:  April 23, 1995
%PURPOSE:
%  Replace all of the NaNs in a vector with a new value.
% 
%

disp('Replace this call with replaceValue.  This routine will disappear.')

res = in;
nReplaced = sum(isnan(in));
res(isnan(in)) = newValue*ones(1,nReplaced);
