function layer1map = createLayer1Map(anatomyDir,anatomyF,hemisphere,grayF)

% Input parameters:
%anatomyDir = '/usr/local/mri/anatomy/baseler2';
%anatomyF = 'vAnatomy.dat';
%hemisphere = 'left';
%grayF = 'leftGray3.dat';

% Get dimdist
cmd = ['load ' anatomyDir '/UnfoldParams'];
eval(cmd)
dimdist = 1./volume_pix_size;

% Load nodes and edges
grayFile = [anatomyDir '/' hemisphere '/' grayF];
[nodes,edges] = readGrayGraph(grayFile);

% Load flat.mat to get glocs2d and gLocs3d
cmd = ['load ' anatomyDir '/' hemisphere '/unfold/flat'];
eval(cmd)

% Create unfList if it doesn't exist
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

% Now we have everything we need to create the layer1map
[layer1map,layer1] = squeeze2layer1(nodes, edges, unfList, dimdist);

% Save unfList and layer1map inside of 'flat.mat'
chdir([anatomyDir '/' hemisphere '/unfold'])
save temp unfList layer1map
clear all
load flat
load temp
save flat
