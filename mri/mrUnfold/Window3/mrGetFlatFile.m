function [flat, flatDirName] = mrGetFlatFile(flat,grayMatter,anatomy);
% function [flat, flatDirName] = mrGetFlatFile(flat,grayMatter,anatomy);
%
% PURPOSE:	GUI for user to enter a directory and file name for the flattened
%		gray matter data.
%
% ARGUMENTS:	flat:		structure that contains two character array fields:
%		  	flat.dir is the name of the flattened gray matter directory
%		  	flat.file is the name of the flattened gray matter file
%		grayMatter:	structure that contains two character array fields:
%		  	grayMatter.hemisphere contains side of brain viewed
%		  	grayMatter.file contains the name of the current file
%		anatomy:	used only if a default directory is needed
%			anatomy.dir is the name of the volume anatomy directory
%			anatomy.file is the name of the volume anatomy file
%				structure that contains two character array fields:
% RETURNS:	flat:		with the new side and/or file name if the user
%				entered a new directory and/or file name
%		flatDirName:	string consisting of 'flat.dir/flat.file'	
%
% SJC - 05.07.98
%

if isempty(anatomy.dir)
  errordlg('No anatomy directory specified.','Load Flat Gray Matter File');
else
  if ~isempty(flat.dir)
    prompt1 = sprintf('Current flattened gray matter directory is ''%s''.\nEnter new directory:',flat.dir);
    defAns1 = flat.dir;
  else
    prompt1 = sprintf('No current flattened gray matter directory specified.\nEnter new directory:');
    defAns1 = [anatomy.dir '/' grayMatter.hemisphere '/unfold'];;
  end

  if ~isempty(flat.file)
    prompt2 = sprintf('Current flattened gray matter file name is ''%s''.\nEnter new file name:',flat.file);
    defAns2 = flat.file;
  else
    prompt2 = sprintf('No current flattened gray matter file specified.  Enter new file name:');
    defAns2 = 'flat.mat';
  end

  answer = inputdlg({prompt1, prompt2},'Load Flat Gray Matter File',1,{defAns1, defAns2});
  
  if ~isempty(answer)
    % The user selected 'OK'
    if ~isempty(char(answer(1)))
      flat.dir = char(answer(1));
    end

    if ~isempty(char(answer(2)))
      flat.file = char(answer(2));
    end

    flatDirName = [flat.dir '/' flat.file];

  else
    % The user selected 'Cancel'
    flatDirName = [];
  end

end

return