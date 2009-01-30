function [xyz_layer_amp_co_ph_dc, binImage, unfList] = ...
		mrFlat2volDat(dataDir,grayDir,side,grayFile,noDataVal)
% function [xyz_layer_amp_co_ph_dc, binImage] = ...
%		mrFlat2volDat(dataDir,grayDir,side,grayFile,noDataVal)
%
% AUTHOR:	SJC, ABP
% DATE:		04.01.98
% PURPOSE:	Finds the (x,y,z) location and layer of each data point in the
%		inplanes by mapping them to the flattened representation and 
%		then from the flattened representation to the volume
%		representation.
% ARGUMENTS:
%	dataDir:	directory where all mrLoadRet data for a particular
%			subject is located
%	grayDir:	directory where gray matter files are located
%	side:		which hemisphere to map, [l]eft, [r]ight, or [b]oth
%	grayFile:	name of gray matter data file
%	noDataVal:	value for points with no fMRI data
% RETURNS:
%	xyz_layer_amp_co_ph_dc:  [x y z layer amp co ph dc] output matrix
%	binImage:	image of how many inplane points mapped to each flattened
%			point (for debugging purposes)
%	unfList:	list of nodes that were unfolded
%
% MODIFICATIONS:
% 06.26.98 SJC	Fixed bug with unfList for cases when the unfolded nodes and edges
%		are saved in flat.mat (unfList should be all the nodes)
	

if nargin < 5
  noDataVal = -99;
end

if (side == 'l')
  hemisphere = 'left';
elseif (side == 'r')
  hemisphere = 'right';
end

% Load data from 'flat.mat'
% Contains: gLocs2d, gLocs3d
% In newer versions maybe also: unfList, layer1map, grayNodes, grayEdges
unfDir = sprintf('%s/%s/unfold',grayDir,hemisphere);

if(check4File([unfDir,'/flat']))
  estr = sprintf('load %s/flat',unfDir);
  disp(estr)
  eval(estr);
else
  sampDist = getSampDist(unfDir);
  fname = [unfDir,'/interp',sampDist];
  if (check4File(fname))
     eval(['load ',unfDir,'/interp',sampDist]);
     eval(['load ',unfDir,'/dist',sampDist]);
     gLocs3d = mrVcoord(xGrayVol',iSize);
     str = ['save ',unfDir,'/flat gLocs2d gLocs3d'];
     eval(str)
     disp('Created a flat.mat. Update it with the name of the unfold paramsFile.')
   else
     error('Cannot find flat.mat or interpXXX.mat');
   end
end

% Load data in 'Fanat_[hemisphere]'
grayData = sprintf('%s/%s/%s',grayDir,hemisphere,grayFile);

estr = sprintf('load %s/Fanat_%s',dataDir,hemisphere);
disp(estr);
%contains: anat, glocs3d, fSize, and on newer files: rowF,colF,
eval(estr);

% Load data in 'FCorAnal_[hemisphere]'
estr = sprintf('load %s/FCorAnal_%s',dataDir,hemisphere);
disp(estr);
%contains: co, amp, ph, dc in flattened representation
eval(estr);

% If grayNodes and grayEdges that were unfolded were not contained in
% the flat file, load the complete list of gray nodes and gray edges
if (~exist('grayNodes') | ~exist('grayEdges'))
  disp(sprintf('readGrayGraph %s',grayData));
  % nodes contains all the original nodes
  [nodes,edges,vsize] = readGrayGraph(grayData);
  clear edges
  % 'unfList' is a vector of nodes that were flattened (it could be a list of
  % all the nodes if we only loaded in the nodes that were unfolded, but this
  % will not change the output
  if (~exist('unfList'))
    disp(sprintf('flat2volDat: unfList not saved, creating it...'));
    [junk1, gLocs3didx, unfList] = intersect(gLocs3d,nodes(1:3,:)','rows');
  
    % NOTE: nodes(1:3,unfList) is equal to gLocs3d(gLocs3didx), a scrambled
    % version of gLocs3d.  Matlab's 'intersect' function does not ensure
    % that the output unfList is in the correct order.  We need to unscramble
    % unfList so that nodes(1:3,unfList) is in exactly the same order as gLocs3d
    [junk2 sortList] = sort(gLocs3didx);
    unfList = unfList(sortList);
  end
else
  % nodes only contains the nodes that were unfolded
  nodes = grayNodes;
  clear grayNodes grayEdges
  unfList = [1:size(nodes,2)];
end

% The vectors 'rowF' and 'colF' should be in the 'Fanat' file,
% If they don't exist, then you must make them
% We use the same algorithm found in gridImage.m
if (~exist('rowF') | ~exist('colF'))
  if ~exist('sFactor')
    sFactor = 1;
    disp(sprintf('flat2volDat: sFactor set to %f\n',sFactor));
  end
  mn(1) = min(gLocs2d(:,1)); mn(2) = min(gLocs2d(:,2));

  colF = floor( sFactor*(gLocs2d(:,1) - mn(1)) + 1);
  rowF = floor( sFactor*(gLocs2d(:,2) - mn(2)) + 1);

end

% Vectorize this [size(gLocs2d,1)x2] data into one vector
vecF = rowF + (fSize(1)*(colF-1));
    
% Find where the inplane measures fall in the flattened gray image.
% We think that if the 'dc' data is zero, then there
% are not inplane measurements at that (x,y) location
dcDataSet = dc(1,:);
dcDataSet = reshape(dcDataSet,fSize(1),fSize(2));
[ipX,ipY] = find(dcDataSet > 0);
ipIdx = find(dcDataSet > 0);

nMeasurementsShown = size(ipIdx,1);
numberOfScans = size(amp,1);
nGrayPoints = size(unfList,1);     % how many gray points were unfolded

xyz_layer_amp_co_ph_dc = noDataVal * ones(nGrayPoints,8,numberOfScans);
binImage = zeros(fSize(1),fSize(2));

% Data from one gray matter point is contained
% in the same row for all the following matrices
% gLocs2d, gLocs3d, unfList, rowF, colF.
% That is how we map from an (x,y) location in the image of the
% flattened data to (xyz) in the volume.
% The gray matter data, only some of which is unfolded,
% is a larger data set and we use another level of indirection
% to get the layer information.

% First we fill the x,y,z positions and the layer for all the nodes
for ii = 1:numberOfScans
  xyz_layer_amp_co_ph_dc(:,1:4,ii) = nodes([1 2 3 6],unfList).';
end

for jj = 1:nMeasurementsShown
  % 'idx' is a list of row indices for
  % all the gLocs3d nodes that get mapped into
  % a given (x,y) point in the image of flattened data
  idx = find(vecF==ipIdx(jj));
  binImage(ipX(jj),ipY(jj)) = length(idx);

  for kk = 1:size(idx,1)
    % Tag this (xyz,layer) location with the 
    % flattened data at the (x,y) location.
    for ii = 1:numberOfScans
      %% This is what it is really doing, but it is too slow....
      % ampDataSet = reshape(amp(ii,:),fSize(1),fSize(2));
      % coDataSet = reshape(co(ii,:),fSize(1),fSize(2));
      % phDataSet = reshape(ph(ii,:),fSize(1),fSize(2));
      % dcDataSet = reshape(dc(ii,:),fSize(1),fSize(2));
      % xyz_layer_amp_co_ph_dc(idx(kk),5:8,ii) = ...
      % [ampDataSet(ipX(jj),ipY(jj)),...
      % coDataSet(ipX(jj),ipY(jj)),...
      % phDataSet(ipX(jj),ipY(jj)),...
      % dcDataSet(ipX(jj),ipY(jj))];

       xyz_layer_amp_co_ph_dc(idx(kk),5:8,ii) = ...
	   [amp(ii,ipIdx(jj)),...
	   co(ii,ipIdx(jj)),...
	   ph(ii,ipIdx(jj)),...
	   dc(ii,ipIdx(jj))];
    end
  end
  if (rem(jj,500) == 0)
    disp(sprintf('flat2volDat: mapping point %d out of %d...',jj,nMeasurementsShown));
  end    
end

[r,c] = find(binImage == mmax(binImage));
disp(sprintf('Max num gray matter points mapped to 1 point in image:'));
disp(sprintf(' %d at (row,col): %d %d',mmax(binImage),r,c));

return
