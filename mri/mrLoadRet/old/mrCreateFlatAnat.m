function anat = mrCreateFlatAnat(side)
% AUTHOR: Geoff Boynton
% DATE: 9/2/96
% USAGE: anat = mrCreateFlatAnat([side])
%  Generates gray-scale image(s) to underly functional maps for
%  flattened fMRI data.  The intensity of the images represent
%  the distance of each point in the flattened representation
%  from their corresponding distance from the midline in 3D.
%
%  SEE ALSO:  viewUnfold.m
% HISTORY: 
% 03.30.98 SJC, ABP -- Added rowF and colF to saved out
% file so that one can unpack the many-to-one mapping from
% 'gLocs2d' to 'anat'.
%  

if (~exist('side'))
  side = input('Flatten (l)eft, (r)ight, or (b)oth? ','s'); 
end
if side == 'b', side = ['l','r']; end

% subject inplane_pix_size
mrLoadAlignParams
load ExpParams 

voldir = '/usr/local/mri/anatomy';
% Load in the pixel size of the volume anatomy
% volume_pix_sizes, 
% 
cmd=(['load ',voldir,'/',subject,'/UnfoldParams']);
eval(cmd);

% This variable governs how the gray matter spatial scale,
% usually in mm, is mapped into pixels in the unfolded
% representation.  When it is set to 1, as here, the flattened
% representation coordinates are also in mm.  Sometimes for
% viewing you may decide to make this bigger.  We don't think
% so. 
sFactorF = 1;

for brainSide = side
  if brainSide == 'l' 
    hemisphere = 'left';
  else 
    hemisphere = 'right';
  end

  unfoldSubDir = '';
  unfdir =  ...
      [voldir,'/',subject,'/',hemisphere,'/unfold/', unfoldSubDir,'/'];
  
  if(check4File([unfdir,'/flat']))
    str = ['load ',unfdir,'/flat'];
    eval(str);
  else
    sampDist = getSampDist(unfdir);
    fname = [unfdir,'/interp',sampDist];
    if (check4File(fname))
       eval(['load ',unfdir,'/interp',sampDist]);
       eval(['load ',unfdir,'/dist',sampDist]);
       gLocs3d = mrVcoord(xGrayVol',iSize);
       str = ['save ',unfdir,'/flat gLocs2d gLocs3d'];
       eval(str)
       disp('Created a flat.mat. Update it with the name of the unfold paramsFile.')
     else
       error('Cannot find flat.mat or interpXXX.mat');
     end
  end

  badpts = isnan(gLocs2d(:,1));
  gLocs2d = gLocs2d(~badpts,:);
  gLocs3d = gLocs3d(~badpts,:);

  kernel = mkGaussKernel([5 5],[2 2]);%original default
  
  cmap=colormap;
  mp = (1:64)' * [1,1,1]; 
  cValues = gLocs3d(:,3);
  if brainSide=='r'
    cValues=max(cValues)-cValues;
  end
  
  cValues = cValues .^ 1.5;
  mpScale = 's';
  
  [tmp rowF colF fSize] =  ...
      viewUnfold(gLocs2d,sFactorF,kernel,mp,cValues,mpScale);
  
  tmp(tmp==length(mp))=zeros(size(find(tmp==length(mp))));
  max_val = length(mp)*2.5;
  
  tmp(1:size(tmp,1),1)=max_val*ones(size(tmp,1),1);
  tmp(1:size(tmp,1),size(tmp,2))=max_val*ones(size(tmp,1),1);
  tmp(1,1:size(tmp,2))=max_val*ones(1,size(tmp,2));
  tmp(size(tmp,1),1:size(tmp,2))=max_val*ones(1,size(tmp,2));
  anat=tmp(:)';
  anatmap = ones(1,numofexps/numofanats);

  %Image size of the flattened representation
  curCrop = [];

  % gLocs3d: (x,y,z) locations of gray matter in the volume anatomy
  % rowF,colF:  locations of gray matter in the flattened rep.
  % 
  [gray2inplane gray2flat] = ...
      mrCreateGray2Image(brainSide,gLocs3d,rowF,colF,fSize);
    
  estr = ['save Fanat_',hemisphere, ...
	  ' anat anatmap fSize curCrop gray2inplane gray2flat gLocs3d rowF colF'];

  disp(estr)
  eval(estr)
    
end 					%brainSide
  






