noDataVal = -99; 
 
%%%%%%%%%%
% Step 1
% Create data from flat image

hemisphere = 'left'; 
% gmb data set on MTColor
dataDir = '/usr/local/mri/MTColor/091197a';        
grayDir = '/usr/local/mri/anatomy/baseler2';
flatFile = 'flat';
grayFile = 'leftGray.dat';
grayData = sprintf('%s/left/%s',grayDir,grayFile);

%%%%%%%%%%
% Create layer 1 map (squeeze all other layers onto layer 1
% This is an expensive computational step.  We have saved
% the output ('layer1map') in the corresponding 'flat.mat' 
% anatomy file.
cd /usr/local/mri/anatomy/baseler2
load UnfoldParams
dimdist = 1./volume_pix_size;
[nodes,edges,vsize] = readGrayGraph(grayData); 
load /usr/local/mri/anatomy/baseler2/left/unfold/flat

[junk1, gLocs3didx, unfList] = intersect(gLocs3d,nodes(1:3,:)','rows');
% NOTE: nodes(1:3,unfList) is equal to gLocs3d(gLocs3didx), a scrambled
% version of gLocs3d.  Matlab's 'intersect' function does not
% ensure that the output unfList is in the correct order.  We need to unscramble
% unfList so that nodes(1:3,unfList) is in exactly the same order as gLocs3d
[junk2 sortList] = sort(gLocs3didx);
unfList = unfList(sortList);

[layer1map,layer1] = squeeze2layer1(nodes, edges, unfList, dimdist);

checkLayer = ismember(layer1map,layer1);

% sum(checkLayer) should be equal to length(unfList)
% layer1map and unfList should be saved as part of the variables inside of 'flat.mat'
