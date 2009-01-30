% mrSaveROI(selpts,[viewPlane],[selpts_left],[selpts_right])
%
%	Saves a region of interest to disk along with the
% number of the series of functional images that it came from.

%9/6/96  gmb  Added viewPlane,selpts_left and selpts_right as
%        optional inputs for loading flattened ROI's

function mrSaveROI(selpts,viewPlane,selpts_left,selpts_right)

if nargin==0
  viewPlane='inplane';
end

ROIname = input('ROI Name? ','s');

if strcmp(viewPlane,'inplane')
  ROIname = [ROIname,'ROI'];
  estr = ['save ',ROIname,' selpts'];
  eval(estr);
else
  
  estr = ['selpts_',viewPlane,' = selpts;'];
  eval(estr);
  
  ROIname = [ROIname,'FROI'];
  estr = ['save ',ROIname,' selpts_left selpts_right'];
  eval(estr);
end

disp(['Saved ',ROIname,'.mat']);


