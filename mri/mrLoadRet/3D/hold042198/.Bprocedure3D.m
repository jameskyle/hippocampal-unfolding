% gmb color data
%cd /usr/local/mri/MTColor/091097
% software sits here for now
%cd /home/poirson/matlab/visual3D

noDataVal = -99; 
 
%%%%%%%%%%
% Step 1
% Create data from flat image

hemisphere = 'left'; 
% gmb data set on MTColor
dataDir = '/usr/local/mri/MTColor/091097';        
grayDir = '/usr/local/mri/anatomy/gmb';
flatFile = 'flat';
grayFile = 'LHGray.dat';

[xyz_layer_amp_co_ph_dc,bimage,unfList]=...
    flat2volDat(dataDir,grayDir,hemisphere,flatFile,grayFile,noDataVal);

save allLayerData xyz_layer_amp_co_ph_dc

cd /home/poirson/matlab/visual3D
% contains [xyz_layer_amp_co_ph_dc]
load allLayerData

%%%%%%%%%%
% Step 2
% Create layer 1 map (squeeze all other layers onto layer 1
% This is an expensive computational step.  We have saved
% the output ('layer1map') in the corresponding 'flat.mat' 
% anatomy file.
clear squeeze2layer1
% Get dimdist
cd /usr/local/mri/anatomy/gmb
load UnfoldParams
dimdist = 1./volume_pix_size;
[layer1map,layer1] = squeeze2layer1(nodes, edges, unfList, dimdist);

checkLayer = ismember(layer1map,layer1);

% Read in the unfList and the layer1map in flat.mat
cd /usr/local/mri/anatomy/gmb/left/unfold
% contains unfList layer1map gLocs2d gLocs3d 
load flat

%%%%%%%%%%
% Step 3
% Compress data from all layers that get mapped to a layer 1 point
clear compressData
% contains [xyz_amp_co_ph_dc]
load compressedData 
[xyz_amp_co_ph_dc,noDataCount] = compressData(xyz_layer_amp_co_ph_dc,layer1map,noDataVal);

% For checking later...
save compressedData xyz_amp_co_ph_dc

%%%%%%%%%%
% Step 4
% Create R,G,B data
% 
% Below Not yet tested....
clear values2RGB

scanNum = 1;
coThresh = 0.40;
pWindow  = [0.0,90];
xyz_phRGB  = values2RGB(xyz_amp_co_ph_dc,'ph',scanNum,noDataVal,coThresh,pWindow);

%%%%%%%%%%
% Step 5
% Save data out in ascii format so that Tim's rendering program
% can read it in
%%-- 04.08.98 ABP SJC
% GMB left brain modeled as *.off file in: gmbLBrain.off
% GMB phase data in [xyz_phRGB] form as: gmbLPh1data.dat
save gmbLPh1data xyz_phRGB -ascii
% Contains 13491 vertices created from writeOFF.m 
%  and the 13491 vertices created from Suelika an my code.
%  There is a bug here because the two aren't identical.
save vertices grayVert offVert 

% I have saved a file full of data vertices that
% do overlap with the OFF vertices in: gmbLPh1dataS
% This is so Tim can work on this.

%%%%%%%%%%%%%%%
% -- 04.08.98 SJC, ABP
% Creating a test case in which a small contiguous region is
% colored to make sure that 3D rendering is correct

R = 43;
G = 119;
B = 91;

% In this case we are looking for the cross-bar location
% **** see R G and B values at beginning
[i,j] = find((nodes(1,:)==B)&(nodes(2,:)== G)&(nodes(3,:)==R));

startNode = j

% Find red points in unfList (I'm pretty sure this works)
[dist,nReached] = mrManDist(nodes,edges,startNode,dimdist,-1,5);
idx = find(dist > 0);
[junk1, junk2, redPts] = intersect(idx,unfList);

figure(1)
plot3(nodes(1,unfList),nodes(2,unfList),nodes(3,unfList),'b.');
hold on
plot3(nodes(1,unfList(redPts)),nodes(2,unfList(redPts)),nodes(3,unfList(redPts)),'rx');

testxyzstuff = xyz_layer_amp_co_ph_dc;
testxyzstuff(:,5:8,1) = -99;
testxyzstuff(redPts,5,1) = 1;
testxyzstuff(redPts,6,1) = 1;
testxyzstuff(redPts,7,1) = pi/4;
testxyzstuff(redPts,8,1) = 1;

[xyz_test,noDataCount] = compressData(testxyzstuff,layer1map,noDataVal);
xyz_out  = values2RGB(xyz_test,'ph',scanNum,noDataVal,0.1);

layer1redPts = find(xyz_out(:,4) ~= 128);
size(layer1redPts)
figure(2)
plot3(xyz_out(:,1),xyz_out(:,2),xyz_out(:,3),'b.')
hold on
plot3(xyz_out(layer1redPts,1),xyz_out(layer1redPts,2),xyz_out(layer1redPts,3),'rx')

% Create output
xyz_RGBA_test = 128*ones(size(xyz_phRGB));
xyz_RGBA_test(:,[1 2 3 7]) = xyz_phRGB(:,[1 2 3 7]);
xyz_RGBA_test(layer1redPts,4) = 255;
xyz_RGBA_test(layer1redPts,5) = 0;
xyz_RGBA_test(layer1redPts,6) = 0;
xyz_RGBA_test(layer1redPts,7) = 255;

save gmbRedTest -ascii xyz_RGBA_test