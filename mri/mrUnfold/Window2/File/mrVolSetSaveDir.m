function saveDir = mrVolSetSaveDir(defaultNeeded,saveDir,anatomy)
% function saveDir = mrVolSetSaveDir(defaultNeeded,saveDir,anatomy)
%
% PURPOSE:	GUI for the user to input a new save directory
% ARGUMENTS:	defaultNeeded:	1 if a default directory is needed, 0 if not
%		saveDir:	current save directory
%		anatomy:	structure with fields 'dir' and 'file'
%				'dir' contains the anatomy directory
%				'file' contains the anatomy file name
% RETURNS:	saveDir:	new save directory
%
% SJC - 05.05.98
%

if (defaultNeeded | isempty(saveDir))
  % If there is a 3D directory within the anatomyDir, then use that as the default
  if (exist([anatomy.dir '/3D']) == 7)
    saveDir = [anatomy.dir '/3D'];

  % Otherwise, use the anatomyDir as the default save directory
  else
    saveDir = anatomy.dir;
  end
end  

% Show the user what the current save directory is and ask let the user input
% a new one keep the same one
%
if ~isempty(saveDir)
  prompt = sprintf('Current save directory is ''%s''.\nEnter new directory [leave blank to keep current directory]:',saveDir);
else
  prompt = sprintf('No current save directory specified.  Enter new directory:');
end

tempDir = inputdlg(prompt);
tempDir = char(tempDir);

if (~isempty(tempDir) & (exist(tempDir) == 7))
  % The user selected 'OK' and entered a valid directory
    saveDir = tempDir;
    % Otherwise, keep current save directory
end

return
