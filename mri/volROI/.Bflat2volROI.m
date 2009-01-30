function flat2volROI(flatROIname,volROIname)
% flat2VolROI(flatROIname,volROIname)
%
% Creates a volume ROI from an ROI in the flattened
% representation.  Volume ROI's are stored in 
% /usr/local/mri/anatomy/<subject>/volROI/<volROIname>.mat
%
% See also ip2VolROI, vol2ipROI, vol2flatROI

%HISTORY:
%9/8/97 gmb abp wrote it.

if nargin ==1
  volROIname = flatROIname;
end

matdr= pwd;
if ~exist('flatROIname')
  flatROIname =input('flat ROI name: ','s');
end

if ~exist('volROIname')
  disp(['default volume ROI name is ',flatROIname]);
  volROIname = input('volume ROI name: ','s');
  if volROIname == ''
    volROIname = flatROIname;
  end
end

%load flattened ROI to get seltps_left and selpts_right
estr = (['load ',flatROIname,'FROI']);
eval(estr);


%loop through the two hemispheres

volROI = [];
for hemnum = 1:2
  
  if hemnum == 1
    hemstr = 'left';
  else
    hemstr = 'right';
  end
  
  estr = ['selpts = selpts_',hemstr,';'];
  eval(estr);
  if selpts ~= []

    %load flattened anatomy to get gray2flat and gLocs3d
    estr = ['load Fanat_',hemstr];
    eval(estr);
  
    grayNodeId = findAll(selpts(1,:),gray2flat);
    volROI = [volROI;gLocs3d(grayNodeId,:)];
  end
end %hemispheres

volROI = [volROI';ones(1,size(volROI,1))];

%save it where the volume anatomies sit.

%find out subject name.
%load AlignParams
% Changed from above APB, HAB 09.16.97
mrLoadAlignParams

voldr = ['/usr/local/mri/anatomy/',subject,'/volROIs'];
chdir(voldr);
estr =(['save ',volROIname,' volROI']);
disp(estr);
eval(estr);
chdir(matdr);
