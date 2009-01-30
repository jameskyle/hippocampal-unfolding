function [mat, nReplaced] = replaceValue(mat,oldValue,newValue)
%
%  mat = replaceValue(mat,oldValue,newValue)
%
%AUTHOR:  Wandell
%DATE:    July, 1995
%PURPOSE:
%  Utility routine to replace all of the locations in a matrix with
% a certain value (oldValue) with a newValue.
%

% 6/4/95 gmb	repaired routine by adding 'res=mat' 
% and 'if (length(list)>0)'
% mat = Z;
% oldValue = NaN
% newValue = 1

if(isnan(oldValue))
	list = find(isnan(mat));
else
	list = find(mat == oldValue);
end

if (length(list)>0)
	mat(list) = ones(size(list))*newValue;
end

if nargout == 2
  nReplaced = length(list);
end
