% script
%
% superData2Vol
%
% like data2Vol, supersamples volume anatomy pixels, and then 
% uses linear interpolation in the inplanes.
% 
% Using point sampling to map co, amp, and ph to volCo, volAmp,
% and volPh.  Writes them out in volCorAnal.mat

sampFactor = 3;  %supersampling factor 
sampList = [1:sampFactor]/sampFactor - 1/(2*sampFactor);

if ~exist('hemisphere')
  hemisphere = 'right';
end

if ~exist('scanNum')
  scanNum=1;
end
if ~exist('cothresh')
  cothresh=0;
end

% load corAnal
if ~exist('co')
  load CorAnal
end

load ExpParams
load anat
mrLoadAlignParams;
load bestrotvol

% *** This may vary across subjects
currDir=pwd;
grayNodeDir=['/usr/local/mri/anatomy/',subject,'/',hemisphere];
chdir(grayNodeDir);

if strcmp(hemisphere,'left')
  grayF='LHGray.dat';
else
  grayF='RHGray.dat';
end    

[grayNodes grayEdges] = readGrayGraph(grayF);
chdir(currDir);

% 4x4 homogeneous tranform that tranforms from volume to inplane.
Xform = inv(inplane2VolXform(rot,trans,scaleFac));
Xform = Xform(1:3,:);

% unwrap the data for the chosen scan
seriesNums=scanSlice2Series(scanNum,1:numofanats,numofexps,numofanats);
subco=co(seriesNums,:)';
subph=ph(seriesNums,:)';
subamp=amp(seriesNums,:)';
subco=subco(:);
subph=subph(:);
subamp=subamp(:);
threshPoints=subco<cothresh;
subco(threshPoints)=NaN*ones(sum(threshPoints),1);
subph(threshPoints)=NaN*ones(sum(threshPoints),1);
subamp(threshPoints)=NaN*ones(sum(threshPoints),1);

%subsample volume anatomy voxels.

volCo = zeros(size(grayNodes,2),1);

coords=[grayNodes(1:3,:); ones(1,size(grayNodes,2))];
for xs = sampList
  for ys = sampList
    for zs = sampList
      disp(sprintf('xs %5.2f, ys %5.2f, zs %5.2f\n',xs,ys,zs));
      % transform grayNode positions to inplanes
      inplaneCoords=Xform*coords; 	%look into this '-.5' business
      inplaneCoords(1,:)= inplaneCoords(1,:) - xs;
      inplaneCoords(2,:)= inplaneCoords(2,:) - ys;
      inplaneCoords(3,:)= inplaneCoords(3,:) - zs;
      
      %Trilinear interpolation here.
      %Calculate real and imaginary components of amp*exp(i*ph);
      realZ = subamp.*cos(subph);
      imagZ = subamp.*sin(subph);
      realVolZ = realVolZ + ...
	  myCinterp3(realZ,curSize,numofanats,inplaneCoords',NaN)';
      imagVolZ = imagVolZ + ...
	  myCinterp3(imagZ,curSize,numofanats,inplaneCoords',NaN)';
      volCo = volCo + ...
	  myCinterp3(subco,curSize,numofanats,inplaneCoords',NaN)';
    end %zs
  end %ys
end %xs

%divide by sampFactor.^3 to get average
realVolZ = realVolZ/sampFactor.^3;
imagVolZ = imagVolZ/sampFactor.^3;
volCo = volCo/sampFactor.^3;

volPh = atan2(imagVolZ,realVolZ);
volPh(volPh<0) = volPh(volPh<0)+pi*2;
      volAmp = sqrt(realVolZ.^2 + imagVolZ.^2);


save volCorAnal volCo volPh volAmp;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% make some fake data for volCorAnal

v=grayNodes(1,:);
maxV=max(v);
minV=min(v);
v=(v-minV)/(maxV-minV);
volCo=v;
volPh=2*pi*v;
volAmp=v;

save volCorAnal volCo volPh volAmp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% make some fake inplane data (co, amp, and ph) to test superData2Vol

co=zeros(size(co));
ph=zeros(size(ph));
amp=zeros(size(amp));
for z=1:numofanats 
  seriesNum=scanSlice2Series(scanNum,z,numofexps,numofanats);
  co(seriesNum,:)=z/numofanats*ones(1,size(co,2));
  ph(seriesNum,:)=2*pi*(z/numofanats)*ones(1,size(co,2));
  amp(seriesNum,:)=z*ones(1,size(co,2));
end

save fakeCorAnal co amp ph
% edit above 
%   load CorAnal -> load fakeCorAnal
%   save volCorAnal -> save fakeVolCorAnal
hemisphere = 'left';
scanNum=1;
cothresh=0;
superData2Vol
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run superData2Vol on some real data

% rotating wedges
dataDir='/teal/u1/mri/dyslexia/10099b/';
chdir(dataDir)
hemisphere = 'right';
scanNum=7;
cothresh=0.1;
superData2Vol
clear all

% expanding rings
%dataDir='/teal/u1/mri/dyslexia/102296/';
dataDir = '/maroon/u2/mri/tmp-102296/';
chdir(dataDir)
hemisphere = 'left';
scanNum=8;
cothresh=0.10;
superData2Vol
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mrVol

load volCorAnal
dataDir = '/maroon/u2/mri/tmp-102296/';
chdir(dataDir)
load fakeVolCorAnal
hemisphere = 'left';
mrVol

viewFlatData

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%brian's retinotopy data

%generating volPh volAmp volCo
dataDir = '/ise0/u2/mri/bwRetino/070397/';
chdir(dataDir)
hemisphere = 'left';
scanNum=1;
cothresh=0.10;
superData2Vol


%viewing
clear all
dataDir = '/ise0/u2/mri/bwRetino/070397/';
chdir(dataDir)
load fakeVolCorAnal
%load volCorAnal
hemisphere = 'left';
mrVol

viewFlatData
