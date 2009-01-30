function seriesNum = ...
    scanSlice2Series(scanNum,sliceNum,numofexps,numofanats)
% function seriesNum = ...
%    scanSlice2Series(scanNum,sliceNum,numofexps,numofanats)

numscans=numofexps/numofanats;
seriesNum=(sliceNum-1)*numscans+scanNum;

return

% debug
numscans=7;
numofanats=8;
numofexps=numscans*numofanats;
scanSlice2Series(1,1,numofexps,numofanats) % 1
scanSlice2Series(2,1,numofexps,numofanats) % 2
scanSlice2Series(7,1,numofexps,numofanats) % 7
scanSlice2Series(1,2,numofexps,numofanats) % 8
scanSlice2Series(7,8,numofexps,numofanats) % 56
