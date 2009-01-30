function mVoxelsStruct = mrClearMarkedVoxels(mVoxelsStruct);
% function mVoxelsStruct = mrClearMarkedVoxels(mVoxelsStruct);
%
% 02.27.98 SJC
% PURPOSE:	Clears the selected marked area
% ARGUMENTS:	mVoxelsStruct	marked area structure, containing six area fields
% RETURNS:	mVoxelsStruct	marked area structure, containing six area fields
%
% MODIFICATIONS:
% 07.13.98 SJC	changed function name from mrVolClearMarkedVoxels to mrClearMarkedVoxels
%


% Find which area is active for editing
switch mVoxelsStruct.selected
  case 1,
    mVoxels = 'mVoxelsStruct.Area1';
  case 2,
    mVoxels = 'mVoxelsStruct.Area2';
  case 3,
    mVoxels = 'mVoxelsStruct.Area3';
  case 4,
    mVoxels = 'mVoxelsStruct.Area4';
  case 5,
    mVoxels = 'mVoxelsStruct.Area5';
  case 6,
    mVoxels = 'mVoxelsStruct.Area6';
  otherwise,				% None
    return;
end

cmd = [mVoxels ' = [];'];
eval(cmd);
