function [selpts,selpts_inplane,selpts_left,selpts_right] = mrLoadROI(viewPlane)	

%function [selpts,selpts_inplane,selpts_left,selpts_right] = mrLoadROI([viewPlane])	
%
% Prompts the user for a filename and loads the previously
% saved region of interest. 

%9/6/96   gmb  Added viewPlane as optional input for loading
%         flattened ROI's
%11/14/96 gmb  fixed a bug.  mrLoadRet wasn't interpreting return
%               parameters properly
	       
if nargin==0
  viewPlane = 'inplane';
end
	

qt = '''';
ROIname = input('ROI Name? ','s');


if strcmp(viewPlane,'inplane')
  ROIname = [ROIname,'ROI'];
else
  ROIname = [ROIname,'FROI'];
end

%check disk for file
if ~check4File(ROIname)
  disp(['file ',qt,ROIname,'.mat',qt,' not found.']);
  return
end

%load the flattened ROI
estr = ['load ',ROIname];
eval(estr);

%manipulate left/right selpts in the appropriate manner
if strcmp(viewPlane,'inplane')
  selpts_left = [];
  selpts_right = [];
  selpts_inplane = selpts;
else
  selpts_inplane = [];
  estr = ['selpts = selpts_',viewPlane,';'];
  eval(estr);
end
  
%we're done now.
disp(['Loaded ',ROIname,'.mat']);

