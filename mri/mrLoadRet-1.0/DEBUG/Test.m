#
# Add feature of flatten stuff to mrLoadRet
#
changeDir('/musr1/mri/contrast/082596')
%changeDir('/usr/local/mri/color/matlab/091695')
mrLoadRet

load ExpParams
load anat

%Fool mrLoadRet into thinking that flattened data is just
%the first slice of the inplane anatomies:
hemisphere = 'right';

numofexps = numofexps/numofanats;
inplane_curSer=curSer;
curSer=mod(curSer-1,numofexps)+1;
str = ['load FtSeries',num2str(curSer),'_',hemisphere];
disp(str);
eval(str);
curSize = fSize;
str = ['load Fanat_',hemisphere];
disp(str);
eval(str);
str = ['load FCorAnal_',hemisphere];
disp(str);
eval(str);
for i=1:numofanats
  set(anatBtnList(i),'Visible','off');
  set(anatBtnList(i),'Value',0);
end
set(anatBtnList(1),'Value',1);
[curImage] = mrSlicoControlRet(curSer, co, ph, anat(anatmap(curSer),:), curSize, curDisplayName,selpts,anatmap,pWindow);


%Switch back to inplanes:
load ExpParams
load anat
load CorAnal
if (exist('inplane_curSer'))
  curSer = inplane_curSer;
end
for i=1:numofanats
  set(anatBtnList(i),'Visible','on');
end

[curImage] = mrSlicoControlRet(curSer, co, ph, anat(anatmap(curSer),:), curSize, curDisplayName,selpts,anatmap,pWindow);







%Create flattened anatomy

mrCreateFlatAnat('b');

%Make flattened tSeries (FtSeries)
mrMakeFTSeries

%Create and save amp, co and ph of flattened data

ltrend='y';
side='b';

mrFCorRet(numofexps/numofanats, imagesperexp, ncycles, junkimages,ltrend,side);


% Loading stuff for flattenTseries
%

%compile the scale factors for inplane and volume anatomies
%
%

%1.  Check whether the flattened image size could be made smaller.
%2.  See what we can just run and what needs to be fixed.
%     To do this we need to fake-out the anatomy part with
%     anatF.mat
     
%     Toggle between flattened and sliced data formats
%     1.  When flattened there should be 1 anat
%     2.  The color map for that anat is still gray, but the gray 
%       will code plane of origin or something.
%     3.  Also, anatmap needs to change and
%     4.  numofexps needs to change to reflect right and left?


sFactor = 1;

eval

kernel = mkGaussKernel([5 5],[2 2]);
mp = cmap(1:129,:); cValues = gLocs3d(:,3); mpScale = 's';

gLocsF = mrGray2Func(gLocs3d,rotM,transV,scaleF);
volumeLength = prod(iSize)*numofanats;
bad = (gLocsF(:,1) > iSize(2)) | (gLocsF(:,2) > iSize(1)) ...
 | (gLocsF(:,3) > numofanats ) | (gLocsF(:,1) < 1)  ...
 | (gLocsF(:,2) < 1) | (gLocsF(:,3) < 1);
xFuncVol = mrVcoord(gLocsF,iSize);
bad = bad | (xFuncVol < 1 )| (xFuncVol > volumeLength);
gLocsF = gLocsF(~bad,:);
goodLocs2d = gLocs2d(~bad,:);

  tmp =  viewUnfold(goodLocs2d,sFactor,kernel,mp,cValues,mpScale);
  anat(1,:) = tmp(:);
  anat(2,:) =   viewUnfold(locs2d,sFactor,kernel,mp,cValues,mpScale);
  numSlices = 2
  numofanats = 2
  numofexps = 2*nExp = 2 * numofexps/numofanats
  curExp = 1
  selpts = [];
  
  there should be only two anatomy buttons in this mode, on the left

load tSeriesF_left1


figure(2)
i = 1
for i=1:size(tSeriesF,1)
  mrShowImage(tSeriesF(i,:),fSize,'s',[ 0 .4 .7; gray(64)]);
  pause(.1)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


mrExtractImgVol ... 
	has interpolation as a possibility
	extracts points from a volume
	This is similar to stuff we do with mrVcoord and indexing
	except that there is some interpolation possibility we
	should figure out.

   volume
   samp = locations of the gray-matter points with respect to the current
	functional data set.

	Each sample point is either
	 * outside of the functional data set, and assigned badVal
	 * inside the functional data set, and it is assigned a
	   volume coordinate within the FUNCTIONAL data set. 
	   Depending

gridImage

flattenFunc

locs3d:	Location of gray matter in the volume anatomy
locs2d: Locations of gray matter in flattened representation

Find myCinterp3.c and put it in


makeExpVolume:  management of some data bullshit

mrMakeFTSeries

mrVol2Func:
	This converts the locations of gray-matter points in 3d volume
	anatomy into their corresponding positions within the current
	functional data set (in pixels).

	The returned values are not locked onto the grid, yet.  The
	interpolation onto the existing functional data points still
	needs to be done.

makeExpVolume


1.  So, we need to 
	* make a tSeriesVolume for one experiment by reading in
	  all the anatomy tSeries for one experiment 
	(analogue to makeExpVolume) 

	* put a temporal frame at a time to mrExtractImgVol by pulling
	  out some of the data in tSeriesVolume 

	* gridImage the result.

	* Think about left and right hemisphere stuff

funcVolIndx <- mrExtractImgVol( flocs3d )

allocate tSeriesF not yet gridded


% Function to create a tSeries for the flattened representation
% Do we make tSeriesF = nInplanes x iSize x nFrames?  Or do we
% make it much smaller, and maintain a list of 
%   the form [row col] <-> tSeriesF(row,col).
%   The first form might be computationally efficient.  But it will
%   also be fairly sparse because most of the pixels are not in gray matter.
%   This second form is MUCH smaller, but harder to compute with.
%
% Suppose there are 
%  8 inplanes, cropped to 100 x 100 (80,000 points)
%  100 temporal samples  (8 x 10^6 measurements)
%  20,000 gray-matter points.a
%  Final flattened image is about 100 x 100 x nFrames
%




%Derivatives???

dy =   [0.0357    0.2489    0.4309    0.2489    0.0357]'*   [0.1077    0.2827         0   -0.2827   -0.1077];
dx = dy'

dy_z = exp(sqrt(-1)*2*pi*dy);
dx_z = exp(sqrt(-1)*2*pi*dx);

%img_z = amp(curSer,:).*exp(sqrt(-1)*ph(curSer,:));
img_z = exp(sqrt(-1)*ph(curSer,:));
img_z=reshape(img_z,curSize(1),curSize(2));

img_z = flipud(img_z);

filt_dy_img_z = conv2(img_z,dy_z,'same');
filt_dy_ph_img = angle(filt_dy_img_z);
filt_dy_ph_img(filt_dy_ph_img<=0)=filt_ph_img(filt_dy_ph_img<=0)+pi*2;
filt_dy_amp_img = abs(filt_dy_img_z);


filt_dx_img_z = conv2(img_z,dx_z,'same');
filt_dx_ph_img = angle(filt_dx_img_z);
filt_dx_ph_img(filt_dx_ph_img<=0)=filt_ph_img(filt_dx_ph_img<=0)+pi*2;
filt_dx_amp_img = abs(filt_dx_img_z);

direction = atan2(filt_dy_amp_img,filt_dx_amp_img);

figure(2);
imagesc(direction);
colormap(hsv);
figure(1)

amp(curSer,:)=filt_amp_img(:)';
ph(curSer,:)=filt_ph_img(:)';




