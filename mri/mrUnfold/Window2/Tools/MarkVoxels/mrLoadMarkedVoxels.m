function mVoxelsStruct = mrLoadMarkedVoxels(mVoxelsStruct,areaName,grayMatter);
% function mVoxelsStruct = mrLoadMarkedVoxels(mVoxelsStruct,areaName,grayMatter);
%
% 02.27.98 SJC
% PURPOSE:	Loads the selected marked area
% ARGUMENTS:	mVoxelsStruct	marked area structure, containing six area fields
%		areaName	filename of area to load
%		grayMatter	structure containing directory anad filename of the
%				gray matter to which the marked area corresponds
% RETURNS:	mVoxelsStruct	marked area structure, containing six area fields
%
% MODIFICATIONS:
% 07.13.98 SJC	changed function name from mrVolLoadMarkedVoxels to mrLoadMarkedVoxels
%		added error and successful load messages to user
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
    errordlg('Cannot load:  no area selected.')
    return;
end

if (~isempty(areaName) & (exist([grayMatter.file '_' areaName]) == 2))
  cmd = ['load ' grayMatter.file '_' areaName ' -mat'];
  eval(cmd);
  cmd = [mVoxels ' = ' areaName ';'];
  eval(cmd);
  
  msgstr = sprintf('%s loaded successfully.',areaName);
  msgdlg(msgstr);
end