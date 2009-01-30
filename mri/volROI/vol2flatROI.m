function vol2flatROI(volROIname,flatROIname)
% vol2flatROI(volROIname,flatROIname)
%
% Creates an ROI in the flattened representation from an ROI in
% volume representation.  Volume ROI's are stored in 
% /usr/local/mri/anatomy/<subject>/volROI/<volROIname>.mat
%
% See also ip2VolROI, vol2ipROI, flat2VolROI

%HISTORY:
%9/8/97 gmb wrote it.

thresh = 0.1;

if nargin ==1
  flatROIname = volROIname;
end

matdr= pwd;
if ~exist('volROIname')
  volROIname =input('vol ROI name: ','s');
end

if ~exist('flatROIname')
  disp(['default flat ROI name is ',volROIname]);
  flatROIname = input('flat ROI name: ','s');
  if flatROIname == ''
    flatROIname = volROIname;
  end
end

matdr = pwd;
mrLoadAlignParams;
volROIdir = ['/usr/local/mri/anatomy/',subject,'/volROIs'];

%load the volume ROI 
chdir(volROIdir)
estr = (['load ',volROIname]);
disp(estr);
eval(estr);
chdir(matdr);

%loop through the two hemispheres
selpts_left = [];
selpts_right = [];
for hemnum = 1:2
  if hemnum == 1
    hemstr = 'left';
  else
    hemstr = 'right';
  end

  %load flattened anatomy to get gray2flat and gLocs3d
  estr = ['load Fanat_',hemstr];
  eval(estr);
  
  gray2vol = mrVcoord(gLocs3d,fSize);
  volROIpts = volROI(1:3,volROI(4,:)>thresh)';
  volROIpts = mrVcoord(volROIpts,fSize);
  
  grayNodeId = findAll(volROIpts,gray2vol);
  selpts = gray2flat(grayNodeId,:);
  selpts = [selpts';ones(1,size(selpts,1))];
  estr = ['selpts_',hemstr,' = selpts;'];
  eval(estr);
end %hemispheres

selpts = [];

estr =(['save ',flatROIname,'FROI selpts_left selpts_right selpts']);
disp(estr);
eval(estr);
