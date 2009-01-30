function [scanNum,sliceNum] = ...
    series2scanSlice(seriesNum,numofexps,numofanats)
% function [scanNum,sliceNum] = ...
%    series2scanSlice(seriesNum,numofexps,numofanats)

numscans=numofexps/numofanats;

scanNum=mod(seriesNum-1,numscans)+1;
sliceNum=(seriesNum-scanNum)/numscans+1;

return

% debug
numscans=7;
numofanats=8;
numofexps=numscans*numofanats;
[scanNum,sliceNum]=series2scanSlice(1,numofexps,numofanats) % [1,1]
[scanNum,sliceNum]=series2scanSlice(2,numofexps,numofanats) % [2,1]
[scanNum,sliceNum]=series2scanSlice(8,numofexps,numofanats) % [1,2]
[scanNum,sliceNum]=series2scanSlice(56,numofexps,numofanats) % [7,8]
