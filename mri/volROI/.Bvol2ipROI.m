function projectVolROIs(ROIlist,hemiFlag)
%
% projects volROI's to the inplanes.  It assumes that the 
% current directory is where we want to blast the ROIs

% gmb's version

%by default, do <ROIname>L and <ROIname>R
if ~exist('hemiFlag')
  hemiFlag == 1;
end

curdr = pwd;
mrLoadAlignParams;
volROIdir = ['/usr/local/mri/anatomy/',subject,'/volROIs'];

if ~exist('ROIlist')
  ROIlist= str2mat('V1','V2D','V2V','V3D','V3V','V3A','V4v','MT');
  
  include = zeros(1,size(ROIlist,1));
  for i=1:size(ROIlist,1);
    ynstr = input(['project ',ROIlist(i,:), '?'],'s');
    if ynstr(1) == 'y'
      include(i) =1;
    end
  end
  ROIlist = ROIlist(include,:)
end

for ROInum = 1:size(ROIlist,1)
  ROIname = ROIlist(ROInum,:);
  while ROIname(length(ROIname)) == ' '
    ROIname = ROIname(1:(length(ROIname)-1));
  end
  if hemiFlag
    hemis = 1:2
  else
    hemis = 0;
  end
  for hemi=hemis
    %%%%%%
    %enter name of the existing ROI
    if hemi==0
      volROIfile=[ROIname]; 		% adds 'ROI' below
    end
    if hemi==1
      volROIfile=[ROIname,'L']; 	% adds 'ROI' below
    end
    if hemi==2
      volROIfile=[ROIname,'R']; 	% adds 'ROI' below
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %load the volume ROI and move it into the current directory
    
    str = (['load ',volROIdir,'/',volROIfile]);
    disp(str)
    eval(str)
    
    newROIfile = volROIfile;

    load ExpParams
    load bestrotvol
    load anat
    disp(['Projecting ',volROIfile,' ...']);
    selpts = volROI2Selpts(volROI,numofanats,curSize,rot,trans,scaleFac,0.4);
    str = (['save ',newROIfile,'ROI',' selpts']);
    disp(str);
    eval(str)
    
  end % hemisphere forloop
end % ROI 
disp('done.');
