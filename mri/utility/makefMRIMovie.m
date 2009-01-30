script
%MakefMRIMovie.m
%
%Generates an image sequence that shows fMRI activity overlayed
%on an anatomical image.  The movie is created using the following:
%
%1.  amplitudes and phases are first vector-averaged across scans.
%2.  amplitudes and phases are spatially blurred.
%3.  active pixels are chosen using a correlation threshold.
%4.  for the remaining pixels, the time course of each pixel intensity
%      modulates as a half-wave recitified sinusoid using amp and ph so
%      that values above zero show appear red with increasing saturation.
%
%  ROIs, anatImg

%
%This command shows the movie:
%M= showMovie(fMRIMovie,cmap);

%4/22/98 gmb  Wrote it.

%example of some basic parameters
%
homedr = pwd;
%datadr = '/usr/local/mri/MTdirsel/082997';  %location of CorAnal data
%nFrames = 64;  %frames per cycle
%gamma = 0.5;   %gamma for scaling greyscale values of anatomy image
%ampFac = 30;   %amplitude scale factor.  
%nBlurs = 2;    %number of spatial blurs with [1,4,6,4,1] square
%              filter on data in the complex plane.
%cothresh = 0.3;  
%sliceNum = 4;  %slice used for animation.
%scanNum = 2;   %scan number (can be a vector for averaging across scans) 
                   %(1 for MT ref, 2 for checkerboard)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load in fMRI data
chdir(datadr)
if ~exist('co')
  disp('Loading CorAnal...');
  load CorAnal
else
  disp('Using existing CorAnal');
end
load anat
load ExpParams
chdir(homedr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pull out and smooth slice/scan data

curSer = scanSlice2Series(scanNum,sliceNum,numofexps,numofanats);
refCurSer = scanSlice2Series(refScanNum,sliceNum,numofexps,numofanats);
%anatImg uses colormap indices from 0 to 63;
anatImg = reshape(anat(sliceNum,:),curSize(1),curSize(2));
anatImg = ((anatImg/mmax(anatImg)).^gamma)*64;

Z = (amp(curSer,:)./dc(curSer,:)).*exp(-sqrt(-1)*ph(curSer,:));
curCo = co(refCurSer,:);
if length(scanNum)>1
  Z = mean(Z);
end
Z = blurIt(Z,nBlurs,curSize);
curCo = blurIt(curCo,nBlurs,curSize);
pts = find(curCo>cothresh);
curAmp = abs(Z(pts));
curPh  = angle(Z(pts));
activityMap = zeros(1,length(pts));
fMRIMovie = zeros(curSize(1),curSize(2),nFrames);
%curPh = zeros(size(curPh));


%Build the colormap:
%colormap is grey from 0 to 64, then red to 128
ramp = linspace(0,1,64)';
blank = zeros(size(ramp));
greys = 0.5*ones(size(blank));

red(1:32,:)  =  0.5+0.5*linspace(0,1,32)';
red(33:64,:) = ones(32,1);
green(1:32,:) = 0.5-0.5*linspace(0,1,32)';
green(33:64,:) = linspace(0,1,32)';
blue(1:32,:)  =  0.5-0.5*linspace(0,1,32)';
blue(33:64,:) = zeros(32,1);

activityCmap = [red,green,blue];
cmap = [gray(64);activityCmap];



%Create the ROI Image

if exist('ROIList')
  if ~exist('ROIColors');
    ROIColors = [0,0,1;0,1,0;1,1,0;0,1,1;1,0,1];
  end
  disp('Creating ROI images...');
  ROIImg = zeros(curSize(1),curSize(2));
  for ROInum=1:length(ROIList)
    chdir(datadr)
    eval(['load ',char(ROIList(ROInum)),'ROI'])
    chdir(homedr)
    tmpPts = selpts(1,find(selpts(2,:)==sliceNum));
    tmpImg = zeros(size(anatImg));
    tmpImg(tmpPts) = ones(size(tmpPts));
    c=ceil(contour(tmpImg,'g'));
    drawnow
    for j=1:size(c,2);
      ROIImg(c(2,j),c(1,j))=128+ROInum;
    end
    cmap = [cmap;ROIColors(ROInum,:)];
    ROIpts = find(ROIImg);
    ROIvals = ROIImg(ROIpts);
  end  
  close
else
  ROIpts = [];
  ROIvals = [];
end

%Build the image sequence
for frameNum = 1:nFrames
  disp(sprintf('building frame %d...',frameNum));
  activityMap = curAmp.*sin((curPh+2*pi*(frameNum-1)/nFrames));
  posPts = find(activityMap>0);
  activityMap = activityMap*64*ampFac+65;
  activityMap = min(activityMap,128);
  img = anatImg;                           %anatomy
  img(ROIpts) = ROIvals;                   %ROI
  img(pts(posPts)) = activityMap(posPts);  %activity
  fMRIMovie(:,:,frameNum) = round(img);      
end

%create a single image to show at the beginning
anatImg(ROIpts) = ROIvals;
return




