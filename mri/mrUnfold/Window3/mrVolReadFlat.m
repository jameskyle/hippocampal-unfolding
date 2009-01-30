function [flatStruct,flat] = mrVolReadFlat(PromptNeeded,flatStruct,flat,gray,anatomy);
% function [flatStruct,flat] = mrVolReadFlat(PromptNeeded,flatStruct,flat,gray,anatomy);
%
% AUTHOR: SJC
% DATE: 03.25.98
% PURPOSE: If necessary, prompts the user to enter a directory and file name under
%	   which to find the unfolded data.  Then Reads in the unfolded data and
%	   returns it.
%

% PromptNeeded will be 1 when user has selected the load new flat file option
% from the menu, and it will be 0 when the user has started mrVol with a
% flat file (flatF) already specified.

origFlat = flat;

if PromptNeeded
  [flat, flatDirName] = mrGetFlatFile(flat,gray,anatomy);
else
  flatDirName = [flat.dir '/' flat.file];
end

% Check to see if the file exists
if (~isempty(flatDirName) & ~(exist(flatDirName) == 2))
    errmsg = sprintf('Invalid file: %s\n',flatDirName);
    h = errordlg(errmsg,'Load Flat File');
    waitfor(h);
    flatDirName = [];
    flat = origFlat;
end

if ~isempty(flatDirName)

  if (exist(flatDirName) == 2)
    cmd = ['load ' flatDirName ' -mat'];
    eval(cmd);
    flatStruct.gLocs2d = gLocs2d;
    flatStruct.unfList = unfList;
  end

  msg = sprintf('Finished reading flat gray matter file: %s\n',flatDirName);
  h = msgbox(msg,'Load Flat File');
  pause(2)
  close(h)

end

return