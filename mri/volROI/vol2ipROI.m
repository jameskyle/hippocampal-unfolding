function vol2ipROI(volROIname,ipROIname)
%
% projects volROI's to the inplanes.  It assumes that the 
% current directory is where we want to blast the ROIs

if ~exist('volROIname')
  volROIname = input('Enter volume ROI name: ','s');
end

if ~exist('ipROIname')
  disp(['Default inplane ROI name is ',volROIname]);
  ipROIname = input('Enter another or press <return> ','s');
  if isempty(ipROIname)
    ipROIname = volROIname;
  end
end

curdr = pwd;
mrLoadAlignParams;
volROIdir = ['/usr/local/mri/anatomy/',subject,'/volROIs'];

str = (['load ',volROIdir,'/',volROIname]);
eval(str)

load ExpParams
load bestrotvol
load anat
disp(['Projecting ',volROIname,' ...']);
selpts = volROI2Selpts(volROI,numofanats,curSize,rot,trans,scaleFac,0.4);
str = (['save ',ipROIname,'ROI',' selpts']);
eval(str)
    
