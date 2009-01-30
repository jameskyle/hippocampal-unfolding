% Peter Shuh's brain
% 
workDir = '/home/poirson/matlab/visual3D';
changeDir('/usr/local/mri/anatomy/gmb')
load UnfoldParams
dimdist = 1 ./volume_pix_size;
cd left
fname = 'LHGray.dat';
[nodes edges] = readGrayGraph(fname);
changeDir(workDir)

% 
firstList = selectFirstLayer(nodes);
% starting point - cross-bar point
R = 43;
G = 119;
B = 91;

% In this case we are looking for the cross-bar location
% **** see R G and B values at beginning
[i,j] = find((nodes(1,:)==B)&(nodes(2,:)== G)&(nodes(3,:)==R));

% Just use the 'j' value for the index needed by 'mrManDist'
%startNode = firstList(n)
startNode = j;

radius = 70;
distList = selectGrayDisk(nodes,edges,startNode,dimdist,radius);
keepList = intersect(distList,firstList);
size(keepList)
[nodes edges] = keepNodes(nodes,edges,keepList);

save tmp nodes edges radius dimdist startNode

[vertices faces] =  gray2mesh(nodes,edges);

size(vertices), size(faces)

nFaces = size(faces,1);
l = ones(nFaces,1);
colors = [0.5*l, 0.5*l, scale(vertices(faces(:,2),1),0,1)];

writeOFF('gmbLBrain.off',vertices,faces,colors);
unix('geomview gmbLBrain.off &')
