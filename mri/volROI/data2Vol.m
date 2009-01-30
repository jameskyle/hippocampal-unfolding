% script
%
% data2Vol
% 
% Using point sampling to map co, amp, and ph to volCo, volAmp,
% and volPh.  Writes them out in volCorAnal.mat


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
grayNodeDir=['/usr/local/mri/anatomy/',subject,'/left'];
chdir(grayNodeDir);
grayF='LHGray.dat';
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

% transform grayNode positions to inplanes, then compute the
% inplaneIndices that correspond with the unwrapped data.
coords=[grayNodes(1:3,:); ones(1,size(grayNodes,2))];
inplaneCoords=round(Xform*coords);

ysize=curSize(1);
xsize=curSize(2);
zsize=numofanats;
inplaneIndices = (inplaneCoords(3,:)-1)*xsize*ysize + ...
    (inplaneCoords(1,:)-1)*ysize + inplaneCoords(2,:);
inplaneIndices=clip(inplaneIndices,1,length(subco));

validPoints = (1<=inplaneCoords(1,:)) & (inplaneCoords(1,:)<=xsize) & ...
    (1<=inplaneCoords(2,:)) & (inplaneCoords(2,:)<=ysize) & ...
    (1<=inplaneCoords(3,:)) & (inplaneCoords(3,:)<=zsize);
invalidPoints = ~validPoints;

volCo=subco(inplaneIndices);
volPh=subph(inplaneIndices);
volAmp=subamp(inplaneIndices);

volCo(invalidPoints)=NaN*ones(1,sum(invalidPoints));
volPh(invalidPoints)=NaN*ones(1,sum(invalidPoints));
volAmp(invalidPoints)=NaN*ones(1,sum(invalidPoints));

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

% make some fake inplane data (co, amp, and ph) to test data2Vol

co=zeros(size(co));
ph=zeros(size(ph));
amp=zeros(size(amp));
for z=1:numofanats 
  seriesNum=scanSlice2Series(7,z,numofexps,numofanats);
  co(seriesNum,:)=z/numofanats*ones(1,size(co,2));
  ph(seriesNum,:)=2*pi*(z/numofanats)*ones(1,size(co,2));
  amp(seriesNum,:)=z*ones(1,size(co,2));
end

save fakeCorAnal co amp ph

% edit above 
%   load CorAnal -> load fakeCorAnal
%   save volCorAnal -> save fakeVolCorAnal
dataDir='/teal/u1/mri/dyslexia/10099b/';
chdir(dataDir)
scanNum=1;
cothresh=0;
data2vol
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rotating wedges
dataDir='/teal/u1/mri/dyslexia/10099b/';
chdir(dataDir)
scanNum=7;
cothresh=0.23;
data2Vol
clear all

% expanding rings
%dataDir='/teal/u1/mri/dyslexia/102296/';
dataDir='/maroon/u2/mri/tmp-102296/';
chdir(dataDir)
scanNum=8;
cothresh=0.23;
data2Vol
clear all

%load volCorAnal
load fakeVolCorAnal
hemisphere = 'left';
mrVol

mrVolL


