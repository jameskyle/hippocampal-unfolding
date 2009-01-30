function [mergedSelpts] = mergeROI(ROIName1,ROIName2,ROIName3,...
    ROIName4,ROIName5,ROIName6,ROIName7,ROIName8,ROIName9,ROIName10);
%
% [mergedSelpts] = mergeROI(ROIName1,ROIName2,ROIName3,...)
%
% AUTHORS:        Heidi Baseler and Geoff Boynton
% DATE:           11.02.97
% PURPOSE:        To generate the union of ROIs
% ARGUMENTS:
% ROIName(n):     Name of ROI (i.e. 'V1L')
% RETURNS:
% mergedSelpts:   2xn matrix (of selpts format) that is the 
%                 union of the ROIs.  Duplicate pixels are removed.

mergedSelpts = [];
qt = '''';
voxCount =0;
for ROINum = 1:nargin
  %evaluates: ROIName = [ROIName<ROINum>,'ROI'];
  estr = ['ROIName = [ROIName',num2str(ROINum),',',qt,'ROI',qt,'];'];
  eval(estr);
  if check4File(ROIName)
    clear selpts
    disp(sprintf('merging %s ',ROIName));
    estr = ['load ',ROIName];
    eval(estr);
    voxCount=voxCount+size(selpts,2);
    mergedSelpts  = mrMergeSelpts(mergedSelpts,selpts);
  else
    disp(['Error: file ',qt,ROIName,qt,' not found.']);
  end
end
disp(['New ROI has ',num2str(size(mergedSelpts,2)),' voxels (',...
	num2str(voxCount-size(mergedSelpts,2)),' duplicates).']);

