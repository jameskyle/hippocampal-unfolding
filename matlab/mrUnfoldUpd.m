%
% mrUnfoldUpd.m
%
% Convert unfold-v2.0 output so that it can be read in by
% mrLoadRet.
%

function mrUnfoldUpd(unfoldDir)

graphFile='/home/teo/HP/src/mrUnfold-2.0/data/boyntonGraph.gray';
[nodes edges] = ReadGrayGraph(graphFile);

% Boynton left
%vSize = [59 55 20];
%vOffset = [ 0 0 0];

vSize = [100 83 51];
vOffset = [34 21 6];


% Update distxxx.m
load '/usr/local/mri/anatomy/boynton/left/unfold-auto/dist333-orig';

iSize = [vSize(2) vSize(1)]; 
nPlanes = vSize(3);
mRadius = 0;

locs_all = nodes([1:3],:)';
for d = 1 : 3
	locs_all(:,d) = locs_all(:,d) + vOffset(d);
	locs0(:,d) = locs0(:,d) + vOffset(d);
end

xGrayVol = locs_all(:,2)+locs_all(:,1)*iSize(1)+locs_all(:,3)*prod(iSize)+1;
xSampVol = locs0(:,2)+locs0(:,1)*iSize(1)+locs0(:,3)*prod(iSize)+1;

xGrayVol = xGrayVol';
xSampVol = xSampVol';

%xGrayVol = mrVcoord(locs_all, iSize)';
%xSampVol = mrVcoord(locs0, iSize)';

autop = 1;

out1 = ' vSize iSize nPlanes sampSpacing dimdist mRadius ';
out2 = ' locs0 locsInitial ';
out3 = ' xGrayVol xSampVol xSampGray nGray nSamp ';
out4 = ' xSampNeighbors dSampNeighbors nRadius nNeighbors autop ';
outData = [out1 out2 out3 out4];
eval(['save /usr/local/mri/anatomy/boynton/left/unfold-auto/dist333', outData]);


