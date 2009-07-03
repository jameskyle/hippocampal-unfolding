function [mergLocs2d,mergLocs3d] = mrMergeFlat(subject,hemisphere,grayfile,unfoldSubDir1,unfoldSubDir2,destSubDir);
%
% mrMergeFlat.m
%
%[mergLocs2d,mergLocs3d] = mrMergeFlat(subject,hemisphere,grayfile,unfoldSubDir1,unfoldSubDir2,destSubDir)
%
% AUTHOR:  	Geoff Boynton
% DATE:    	12.17.96
% MODIFIED BY: 	Heidi Baseler
% UPDATE: 	3.07.97
% PURPOSE:
%	This function permits the user to take two sections of flattened 
% 	brain originating from the same volume and merge them to form one,
%	larger, flattened representation.
%
% ARGUMENTS:
% subject:  	Subject directory where unfolded data live (e.g. 'woodfill')
% hemisphere:	'right' or 'left'
% grayfile:	File containing 3d volume of selected gray matter (e.g. 'right.gray')
% unfoldSubDir1: Subdirectory within unfold directory containing first flattened
%		 representation to be merged.
% unfoldSubDir2: Subdirectory within unfold directory containing second flattened
%		 representation to be merged.
% destSubDir:	 Destination subdirectory, where merged flattened representation 
% 		 will be stored.
%
% RETURNS:
% mergLocs2d:	Coordinates of gray matter in 2-d (merged, flattened) representation.
% mergLocs3d:	Coordinates of gray matter in 3-d (merged, volume) representation.
%
% NOTE:  mrMergeFlat presents you with two possible merge outcomes, "unflipped"
%        and "flipped".  You choose the one that makes sense, based on the two
%        figures and the errors displayed in the command window.
%        mrMergeFlat also gives you the option to save the output into another 
%        unfold subdirectory so that you can load it later into mrLoadRet and
%        project functional data onto the new merged surface.
%
% UPDATE:
% 03.07.97:  Heidi - Updated it to handle unfold-3.0 way of storing variables.
%		   - Made it into a function, tested it and made it public.
% 07.08.98:  SJC   - Replaced usage of 'VAR ~= []' with '~isempty(VAR)'


% Debug variables:
%subject = 'ruddock/gy_120196';
%hemisphere = 'right';
%grayfile = 'right.gray';
%unfoldSubDir1 = 'medial';
%unfoldSubDir2 = 'lateral';
%destSubDir = 'rightmedlat';

curDir = pwd;
voldir = '/usr/local/mri/anatomy';

% Marker size for drawing
mksz = 5;

% HB - Read in gray matter file to get image dimensions (iSize)
%
graydir = [voldir,'/',subject,'/',hemisphere];
chdir(graydir);
[nodes, edges, vSize] = readGrayGraph(grayfile);
iSize = [vSize(1) vSize(2)];
chdir(curDir);

% Load in the pairs of flattened anatomies
% Save 2d locations in gLocs2d_1 and gLocs2d_2
% HB - Convert gLocs3d into volume locations in xGrayVol_1 and xGrayVol_2
for unfnum = 1:2
  unfdir = [voldir,'/',subject,'/',hemisphere,'/unfold/'];
  eval(['unfdir = [unfdir,unfoldSubDir',int2str(unfnum),'];']);
  unfdir = [unfdir,'/'];
% Using new unfolding (unfold-3.0)
% HB - Load "flat.mat" file, which contains gLocs2d and gLocs3d
  eval(['load ',unfdir,'/flat']);
% HB - Using mrVcoord to create xGrayVol from gLocs3d loaded from "flat.mat"
  [xGrayVol] = mrVcoord(gLocs3d,iSize);
  badpts = isnan(gLocs2d(:,1));
  gLocs2d = gLocs2d(~badpts,:);
  xGrayVol = xGrayVol(~badpts);
  eval(['gLocs2d_',int2str(unfnum),' = gLocs2d;']);
  eval(['xGrayVol_',int2str(unfnum),' = xGrayVol;']);
end

clear gLocs2d xGrayVol gLocs3d
orig_gLocs2d_1 = gLocs2d_1;

for flip = 0:1
  if flip ==0
    disp(['Unflipped:']);
  else
    disp('Flipped:');
  end
  
  figure(flip+1)
  % SJC - 07.08.98
  %clg
  clf
  if flip==1
    gLocs2d_1(:,2)=-orig_gLocs2d_1(:,2);
  else
    gLocs2d_1(:,2)=orig_gLocs2d_1(:,2);
  end
  
% Look for intersections of the volumes
  count = 0;
  clear overlappts1 overlappts2 
  idlist = [];
  for i=1:length(xGrayVol_1)
    id = find(xGrayVol_2==xGrayVol_1(i));
    
    % SJC - 07.08.98
    if ~isempty(id)
%    if id~=[]
% Create complex valued coordinates
      count=count+1;
      overlappts1(count,1) = gLocs2d_1(i,1) + sqrt(-1)*gLocs2d_1(i,2);
      overlappts2(count,1) = gLocs2d_2(id,1) + sqrt(-1)*gLocs2d_2(id,2);
      idlist = [idlist;[i,id]];
    end
  end
  
  if count==0
    disp(['No intersection was found between flattened regions!']);
    return
  end
  
% Plot the first piece of unfolded brain (before merging)
  subplot(3,2,1)
  plot(gLocs2d_1(:,1),gLocs2d_1(:,2),'r.','MarkerSize',mksz);
  hold on
  plot(gLocs2d_1(idlist(:,1),1),gLocs2d_1(idlist(:,1),2),'b.','MarkerSize',mksz);
  set(gca,'AspectRatio',[1,1])
  hold off
  
% Plot the second piece of unfolded brain (before merging)
  subplot(3,2,2)
  plot(gLocs2d_2(:,1),gLocs2d_2(:,2),'g.','MarkerSize',mksz);
  hold on
  plot(gLocs2d_2(idlist(:,2),1),gLocs2d_2(idlist(:,2),2),'b.','MarkerSize',mksz);
  set(gca,'AspectRatio',[1,1])
  hold off
  
% Plot the overlapping points (without merging)
  subplot(3,2,3)
  plot(overlappts1,'r.','MarkerSize',mksz);
  hold on
  plot(overlappts2,'g.','MarkerSize',mksz);
  set(gca,'AspectRatio',[1,1])
  hold off
  
% Make a matrix big enough to hold the data from both unfolded datasets
  tmp = zeros(1,max(max(xGrayVol_1),max(xGrayVol_2)));
  tmp = zeros(max(max(xGrayVol_1),max(xGrayVol_2)),1);
  
  tmp(xGrayVol_1)=tmp(xGrayVol_1)+ones(size(xGrayVol_1));

% Find the overlapping points between the two datasets
  intersection = find(tmp(xGrayVol_2)==1);
  
% Calculate the rotation the gives the best-fitting (LSE) merge between the
% two sets of overlapping points
  dx = 0;
  dy = 0;
  theta = 0;
  var = fmins('ErrFun',[dx,dy,theta],0,[],overlappts1,overlappts2);
  keyboard
  err = ErrFun(var,overlappts1,overlappts2);
  disp(['Average error: ',num2str(sqrt(err)/length(overlappts1)),' mm.']);
  z = var(1)+sqrt(-1)*var(2);
  theta = var(3);
  
% Plot the overlapping points after merging
  subplot(3,2,4)
  plot(z+exp(sqrt(-1)*theta)*overlappts1,'r.','MarkerSize',mksz);
  hold on
  plot(overlappts2,'g.','MarkerSize',mksz);
  set(gca,'AspectRatio',[1,1])
  hold off

  rotMat = [cos(theta), sin(theta) ; ...
      -sin(theta),cos(theta)];
  
  newgLocs2d_1 = gLocs2d_1*rotMat;
  newgLocs2d_1(:,1)=newgLocs2d_1(:,1)+real(z);
  newgLocs2d_1(:,2)=newgLocs2d_1(:,2)+imag(z);
  
% Plot the two datasets after merging
  subplot(3,2,5)
  plot(newgLocs2d_1(:,1),newgLocs2d_1(:,2),'r.','MarkerSize',mksz);
  hold on
  plot(gLocs2d_2(:,1),gLocs2d_2(:,2),'g.','MarkerSize',mksz);
  set(gca,'AspectRatio',[1,1])
  hold off
  
% Use the idlist to average the intersection points
  mergedgLocs2d = newgLocs2d_1;
  mergedxGrayVol = xGrayVol_1;
  
% Take the mean for the intersections
  mergedgLocs2d(idlist(:,1),:) = (newgLocs2d_1(idlist(:,1),:)+gLocs2d_2(idlist(:,2),:))/2;
  
% Tack on remainder
  id = ones(size(gLocs2d_2,1),1);
  id(idlist(:,2))=zeros(size(idlist(:,2)));

  keyboard
  mergedgLocs2d=[mergedgLocs2d;gLocs2d_2(id,:)];
  mergedxGrayVol=[mergedxGrayVol;xGrayVol_2(id,:)];
  
% Plot the two datasets after merging, highlighting the averaged, overlapping points
  subplot(3,2,6)
  plot(mergedgLocs2d(:,1),mergedgLocs2d(:,2),'m.','MarkerSize',mksz);
  hold on
  plot(mergedgLocs2d(idlist(:,1),1),mergedgLocs2d(idlist(:,1),2),'b.','MarkerSize',mksz);
  hold off
  set(gca,'AspectRatio',[1,1])
  ChangeColors('m',[0.5,.5,0.5]);
  
  if flip==0
    mergedgLocs2d_unflip = mergedgLocs2d;
    mergedxGrayVol_unflip = mergedxGrayVol;
  end
end

% Make a decision about which is the correct way to merge (choose
% unflipped (figure 1) or flipped (figure 2)
tmp = input('(f)lipped or (u)nflipped? ','s');
if tmp(1)=='u'
  mergLocs2d = mergedgLocs2d_unflip;
  xGrayVol = mergedxGrayVol_unflip;
else
  mergLocs2d = mergedgLocs2d;
  xGrayVol = mergedxGrayVol;
end

% HB - Convert new merged xGrayVol (volume points) to gLocs3d (3d coordinates)
[mergLocs3d] = mrVcoord(xGrayVol,iSize); 

% Save the merged results
yn = input('Save the results? ','s');
if yn(1)=='y'
  unfdir = [voldir,'/',subject,'/',hemisphere,'/unfold/',destSubDir];

% HB - If destination directory doesn't exist, create it
  if ~exist('unfdir')
     makeDirect = ['mkdir ', unfdir];
     unix(makeDirect);
  end

% Using new unfolding conventions, and save merged output.
  gLocs2d = mergLocs2d;
  gLocs3d = mergLocs3d;
  eval(['save ',unfdir,'/flat', ' gLocs2d gLocs3d']);
end

disp('done.')

