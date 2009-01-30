function out = mrCreateOFF(saveDir,offFileName,grayDir,grayFile,side)
% function out = mrCreateOFF(saveDir,offFileName,grayDir,grayFile,side)
%
% AUTHOR: SJC
% DATE: 04.14.98
% PURPOSE: creates an '.off' file that contains the vertices and polygons
%	   for rendering the gray matter.
% ARGUMENTS:
%	saveDir:	directory for saving '.off' file in
%	offFileName:	name to save '.off' file under
%	grayDir:	directory where the gray matter file 'grayFile'
%			is located
%	grayFile:	gray matter file (contains nodes and edges)
%	side:		which hemisphere to unfold: [l]eft or [r]ight
% RETURNS:
%	nothing
%

if (side == 'l')
  hemisphere = 'left';
elseif (side == 'r')
  hemisphere = 'right';
end

% Load data from 'flat.mat' (need gLocs3d)
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

% Load in the gray matter data points
grayData = sprintf('%s/%s/%s',grayDir,hemisphere,grayFile);
fprintf('Reading in gray matter data in %s.\n',grayData);
[nodes, edges, vSize] = readGrayGraph(grayData);

% Make unfList if it was not saved in 'flat.mat'
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

% Keep only the nodes and edges that were unfolded and that are on the first layer
fprintf('Creating list of unfolded first layer nodes and edges...\n');
layer1list = find(nodes(6,:) == 1);
keepList = intersect(layer1list,unfList);
[nodes edges] = keepNodes(nodes,edges,keepList);

% Create the list of vertices and faces from the triangulization
fprintf('Creating list of vertices and faces from triangulization.\n');
[vertices faces] =  gray2mesh(nodes,edges);

% Create list of dummy colors (these will not be the colors used for rendering
% we just need the file to contain data in those locations)
nFaces = size(faces,1);
l = ones(nFaces,1);
colors = [0.5*l, 0.5*l, scale(vertices(faces(:,2),1),0,1)];

% Save '*.off' file
chdir(saveDir)
writeOFF(offFileName,vertices,faces,colors);

return
