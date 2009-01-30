function ip2volROI(ipROIname,volROIname)
% ip2VolROI(ipROIname,volROIname)
%
% Creates a volume ROI from an inplane ROI  
% Volume ROI's are stored in 
% /usr/local/mri/anatomy/<subject>/volROI/<volROIname>.mat
%
% See also vol2ipROI, vol2flatROI, flat2VolROI
%          

%HISTORY:
%9/8/97 gmb abp wrote it.

matdr = pwd;
if nargin ==1
  volROIname = ipROIname;
end

matdr= pwd;
if ~exist('ipROIname')
  ipROIname =input('inplane ROI name: ','s');
end

if ~exist('volROIname')
  disp(['default volume ROI name is ',ipROIname]);
  volROIname = input('volume ROI name: ','s');
  if volROIname == ''
    volROIname = ipROIname;
  end
end

%Get subject name
mrLoadAlignParams

% directory where ROIs are written to
voldr=['/usr/local/mri/anatomy/',subject,'/volROIs'];
load bestrotvol
load ExpParams
load anat
estr = (['load ',ipROIname,'ROI']);
disp(estr);
eval(estr);
volROI = selpts2VolROI(selpts,numofanats,curSize,rot,trans,scaleFac);
chdir(voldr);
estr=(['save ',volROIname,' volROI']);
disp(estr);
eval(estr);
chdir(matdr);
disp('done.');
