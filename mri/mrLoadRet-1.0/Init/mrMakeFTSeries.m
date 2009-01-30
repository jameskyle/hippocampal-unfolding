function mrMakeFTSeries(side)
% mrMakeFTSeries([side])
%
%   Creates time-series matrices for fMRI data in the flattened
% representation.  Optional input variable 'side' determines
% which hemishpere(s) to be analyzed ('l'eft, 'r'ight , or 'b'oth)
%
%   Files are stored in the current directory under the names:
%   FtSeries<n>_left.mat and FtSeries<n>_right.mat where
%   <n> is the scan number.

%  9/2/96  gmb, bw  Created it.

% load in experimental parameter values
load ExpParams 
% load inplane anatomy and anatmap
load anat

if side == 'b', side = ['l','r']; end
for brainSide = side

  if brainSide == 'l' 
    hemisphere = 'left';
  else 
    hemisphere = 'right';
  end

  %Load in flattened anatomy which includes variables:
  %anat anatmap fSize curCrop gray2inplane gray2flat
  %
  eval(['load Fanat_',hemisphere]);
  
  %include junk images in the flattened tSeries
  tFrames = 1:imagesperexp;
  %left  hemisphere flattened tSeries names are: FtSeries<exp>_left
  %right hemisphere flattened tSeries names are: FtSeries<exp>_right
  nExp = numofexps/numofanats;
  for exp = 1:nExp
    tSeries =  ...
	flatTseries(gray2flat,gray2inplane, ...
	numofanats,curSize,fSize,tFrames,exp,nExp);
    fname = sprintf('FtSeries%d_%s',exp,hemisphere);
    cmd = ['save ',fname,' tSeries fSize'];
    disp(cmd)
    eval(cmd);
  end
  
end  %brainSide loop
