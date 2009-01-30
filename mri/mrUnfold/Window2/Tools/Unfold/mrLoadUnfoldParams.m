% mrLoadParams
% script
%
% AUTHOR:	SJC
% DATE:		05.24.98
% PURPOSE:	Callback for loading an existing parameters file from the
%		Unfolding gui.
% MODIFICATIONS:
% 07.09.98 SJC	Added error messages when file does not exist and when the
%		gray matter file indicated in the parameters file to be
%		loaded does not match the current gray matter file

pFile = get(paramsFile_edit,'String');
% Get rid of the '.m' at the end of the file name
idx = length(pFile);
if (pFile(idx-1:idx) == '.m')
  pFile(idx-1:idx) = [];
end

paramsFileDirName = [get(unfSaveDir_edit,'String') '/' get(paramsFile_edit,'String')];

% Check to see if the specified paramsFile exists
if exist(paramsFileDirName,'file')
  curDir = pwd;
  chdir(get(unfSaveDir_edit,'String'));
  eval(pFile);
  chdir(curDir);
  
  % Check to see if the unfolded gray matter file matches the 
  % loaded gray matter file
  if strcmp(graphFile,[anatomy.dir '/' grayMatter.hemisphere '/' grayMatter.file])
  
    % Load all the parameters inside the paramsFile
    if (radius > 0)
      set(radius_edit,'String',num2str(radius));
      volStruct.radius = radius;
    end
    
    set(Node_edit,'String',num2str(startPoint));
    updated = 'idx';
    mrUpdateStartPoint;
    
    set(dimdist_edit,'String',num2str(dimdist));
    set(plane_edit,'String',num2str(P));
    set(display_chk,'Value',vis);
    set(save_chk,'Value',saveFlag);
    set(sampSpacing_edit,'String',num2str(sampSpacing));
    set(nIter_edit,'String',num2str(nIter));
    set(rSamp_edit,'String',num2str(rSamp));
    set(flatWeight_edit,'String',num2str(flatWeight));
    set(penaltyFunc_edit,'String',num2str(penalty));
    set(M_edit,'String',num2str(M));
    if exist('rSeed')
      set(rSeed_edit,'String',num2str(rSeed));
    else
      set(rSeed_edit,'String','0');
    end
  else
    errstring = sprintf('%s does not match current gray matter file.\n',graphFile);
    errstring = [errstring 'Parameters file not loaded.'];
    errordlg(errstring);
  end
else
  errstring = sprintf('%s does not exist.\n',paramsFileDirName);
  errstring = [errstring 'Parameters file not loaded.'];
  errordlg(errstring);
end

