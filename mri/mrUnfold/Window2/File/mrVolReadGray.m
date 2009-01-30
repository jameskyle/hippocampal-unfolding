function [grayMatter,grayStruct,layer1Struct] = ...
	mrVolReadGray(grayMatter,grayStruct,layer1Struct,anatomy);
% function [grayMatter,grayStruct,layer1Struct] =
%	 mrVolReadGray(PromptNeeded,grayMatter,grayStruct,layer1Struct,anatomy);
% 
% AUTHOR: SJC
% DATE: 01.18.98
% PURPOSE: Reads in a gray file
%

% PromptNeeded will be 1 when user has selected the load new gray file option
% from the menu, and it will be 0 when the user has started mrVol with a
% gray file (grayF) already specified.

grayDirName = [anatomy.dir '/' grayMatter.hemisphere '/' grayMatter.file];

% Check to see if the file exists
if (~isempty(grayDirName) & ~(exist(grayDirName) == 2))
    errmsg = sprintf('Invalid file: %s\n',grayDirName);
    h = errordlg(errmsg,'Load Gray File');
    waitfor(h);
    grayDirName = [];
    grayMatter = [];
end

if ~isempty(grayDirName)
    
  [grayStruct.nodes grayStruct.edges] = readGrayGraph(grayDirName);

  msg = sprintf('Finished reading gray matter file: %s\n',grayDirName);
  h = msgbox(msg,'Load Gray File');
  pause(1)
  
  grayStruct.dist = [];

  layer1Struct = mrSelectLayer1(grayStruct,grayMatter,anatomy);

  % Patrick uses postions like a C programmer, starting at 0.
  % Matlab indexing probably starts with 1.  So, 
  grayStruct.nodes(1,:) = grayStruct.nodes(1,:) + 1;
  grayStruct.nodes(2,:) = grayStruct.nodes(2,:) + 1;
  grayStruct.nodes(3,:) = grayStruct.nodes(3,:) + 1;

end

return
