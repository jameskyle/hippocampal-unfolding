function [anatomy,volStruct,displayStruct,grayStruct,layer1Struct,cutNodes] = ...
	mrVolReadVolume(anatomy,volStruct,displayStruct,grayStruct,layer1Struct,cutNodes);
% function [anatomy,volStruct,displayStruct,grayStruct,layer1Struct,cutNodes] = ...
%	mrVolReadVolume(anatomy,volStruct,displayStruct,grayStruct,layer1Struct,cutNodes);
%
% AUTHOR:	SJC
% DATE:		05.01.98
% PURPOSE:	read in a volume anatomy file, initialize related structures


anatomyDirName = [anatomy.dir '/' anatomy.file];

% Check to see if the file exists
if (~isempty(anatomyDirName) & ~(exist(anatomyDirName) == 2))
    errmsg = sprintf('Invalid file: %s\n',anatomyDirName);
    h = errordlg(errmsg,'Load Anatomy File');
    waitfor(h);
    anatomyDirName = [];
    anatomy.dir = [];
    anatomy.file = [];
end

% If file directory and name are valid, read in the new data
if ~isempty(anatomyDirName)
  [volStruct.vData, volStruct.vSize] = readVolume(anatomyDirName);
  volStruct.vData = reshape(volStruct.vData,volStruct.vSize(3),volStruct.vSize(1),volStruct.vSize(2));

  msg = sprintf('Finished reading volume anatomy file: %s\n',anatomyDirName);
  h = msgbox(msg,'Load Volume Anatomy File');
  pause(1)

  % Reading in UnfoldParams to get dimdist
  load([anatomy.dir '/UnfoldParams'])
  volStruct.dimdist = 1./volume_pix_size;
  clear volume_pix_size;

  % Setting the default radius
  volStruct.radius = 20;
  
  % This is matrix for the vSize for different slice orientations
  vSizeM = zeros(3,3);
  % Sagittal dimensions stay the same
  vSizeM(1,:) = volStruct.vSize(1,:);
  % Axial dimensions 
  vSizeM(2,1) = volStruct.vSize(3);
  vSizeM(2,2) = volStruct.vSize(2);
  vSizeM(2,3) = volStruct.vSize(1);
  % Coronal dimensions 
  vSizeM(3,1) = volStruct.vSize(3);
  vSizeM(3,2) = volStruct.vSize(1);
  vSizeM(3,3) = volStruct.vSize(2);
 
  volStruct.vSize = vSizeM;

  % Set some things to defaults if they haven't been set by user
  if ~exist('displayStruct.iNumber')		% [sagittal,axial,coronal]
    displayStruct.iNumber(1) = round(volStruct.vSize(1,3)/2);
    displayStruct.iNumber(2) = round(volStruct.vSize(1,1)/2);
    displayStruct.iNumber(3) = round(volStruct.vSize(1,2)/2);
  end

  displayStruct.flags = [-1 -1 -1 -1];

  grayStruct.nodes = [];
  grayStruct.edges = [];
  grayStruct.selectedNode = -1;
  grayStruct.dist = [];

  layer1Struct.nodes = [];
  layer1Struct.edges = [];
  layer1Struct.selectedNode = -1;
  layer1Struct.dist = [];

  cutNodes = [];

end

return


