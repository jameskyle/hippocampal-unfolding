% replaceValue.m
% --------------
%
% function [mat, nReplaced] = replaceValue(mat, oldValue, newValue)
%
%
%  AUTHOR: Brian Wandell
%    DATE: July, 1995
% PURPOSE:
%       Utility routine that replaces all the locations in a matrix 
%       with a certain value (oldValue) to a newValue.
%
% ARGUMENTS:
%          mat: The matrix in which certain values will be replaced.
%     oldValue: The old value in the matrix which is going to be replaced.
%     newValue: The new value!
%
% RETURNS:
%            mat: The matrix with the replaced values.
%      nReplaced: The number of values replaced.
%
%

function [mat, nReplaced] = replaceValue(mat, oldValue, newValue)


%% Find out which values should be replaced.
%
 if(isnan(oldValue))
   list = find(isnan(mat));
 else
   list = find(mat == oldValue);
 end


%% If some values need replacing then go ahead and do it. 
%
 if (length(list)>0)
   mat(list) = ones(size(list))*newValue;
 end


%% Return the number of values replaced.
%
 if nargout == 2
   nReplaced = length(list);
 end


%%%%
