function [new, jROI, ROIList] = NewROIPlot(ROIName, ROIList)

% function [new, jROI, ROIList] = NewROIPlot(ROIName, ROIList);
%
% Check the input ROIName against the cell array ROIList. If the
% name is not already present, then add it to the list, and set
% the logical flag new true; otherwise set it false. In all
% cases, set iROI to the index of the ROIName in the ROIList.

new = 1; % By default
nROIs = length(ROIList);
for iROI=1:nROIs
  if strcmp(ROIName, ROIList{iROI})
    jROI = iROI;
    new = 0;
    break
  end
end

if new
  jROI = nROIs + 1;
  ROIList{jROI} = ROIName;
end
