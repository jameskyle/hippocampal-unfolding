function oneImage = ...
    ExtractVolImage(vData,vSize,displayStruct)
% oneImage =  ExtractVolImage(vData,vSize,displayStruct)
% AUTHOR:  Poirson
% DATE:    03.17.97
% PURPOSE: Extract one image from a volume anatomy data set
%   displayStruct.activeSliceOri = 1  Sagittal View
%                    2  Axial View
%                    3  Coronal View
% HISTORY: Today is St. Patrick's Day, whoever that was.
%	11.10.97 SJC -- changed vData to a 3D matrix, simplified image extraction
%	12.12.97 SJC -- moved some variables to a structure
% TODO:
% 

switch displayStruct.activeSliceOri

  case 1,				% Sagittal 
	oneImage = vData(displayStruct.iNumber(displayStruct.activeSliceOri),:,:);

  case 2,				% Axial
	oneImage = vData(:,displayStruct.iNumber(displayStruct.activeSliceOri),:);

  case 3,				% Coronal
	oneImage = vData(:,:,displayStruct.iNumber(displayStruct.activeSliceOri));

  otherwise,
  	disp('ERROR ExtractVolImage: Invalid slice orientation');
	return;
end


