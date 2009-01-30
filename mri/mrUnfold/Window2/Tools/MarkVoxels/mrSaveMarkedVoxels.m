function out = mrSaveMarkedVoxels(mVoxelsStruct,areaName,grayMatter);
% function out = mrSaveMarkedVoxels(mVoxelsStruct,areaName,grayMatter);
%
% 02.27.98 SJC
% PURPOSE:	Saves the selected marked area
% ARGUMENTS:	mVoxelsStruct	marked area structure, containing six area fields
%		areaName	filename of area to load
%		grayMatter	structure containing directory anad filename of the
%				gray matter to which the marked area corresponds
% RETURNS:	nothing
%
% MODIFICATIONS:
% 07.13.98 SJC	changed function name from mrVolSaveMarkedVoxels to mrSaveMarkedVoxels
%		added error and successful save messages to user
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
  otherwise,
    errordlg('Cannot save:  no area selected.');
    return;
end

if ~isempty(areaName)
  cmd = [areaName ' = ' mVoxels ';'];
  eval(cmd);
  cmd = ['save ' grayF '_' areaName ' ' areaName];
  eval(cmd);
  
  msgstr = sprintf('%s saved successfully.',areaName);
  msgdlg(msgstr);  
end