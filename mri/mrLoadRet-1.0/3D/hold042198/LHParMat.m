% LHParMat.m

subject='gmb'
hemisphere='left'
% starting point - cross-bar point
R = 43;
G = 119;
B = 91;
radius = 70; % in mm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up the path for loading the raw data. 
%
if hemisphere(1)=='l'
  foo='LH';
else
  foo='RH';
end

graphFile= ['/usr/local/mri/anatomy/', ...
	subject,'/',hemisphere,'/',foo,'Gray.dat']

%% Set up directory path for saving the results.
%
 saveDir = ['/usr/local/mri/anatomy/',subject,'/',hemisphere,'/unfold']

%% Variable initializations used in unfoldDist.
%% These are the values for JW specifically.
% These values must be in mm/pixel, which is different
% for mrLoadVol and mrLoadRet which uses pixel/mm 
% (say HAB -- Valentine's Day '97)
% To find out these values go to the Ifiles directory and type
% (from a HP):  read_header I.001
% This gives you field-of-view and slice thickness in
% millimeters.  Use these for the numerator, the denominator 
% will probably always be 256, 256, 1, which are the pixel
% dimensions for the MR captured image.
xmmpix = 240/256
ymmpix = 240/256
zmmpix = 1/1
dimdist = [xmmpix ymmpix zmmpix]

% Choose the center point of the unfold.  From this point
% we will take X mm radially to unfold.
% Need to figure out where the node value is by searching
% through the 'nodes' data for the B,R,G cross-bar point
% in 'mrGray'.
[nodes, edges, vSize] = readGrayGraph(graphFile);
% In this case we are looking for the cross-bar location
% **** see R G and B values at beginning
 [i,j] = find((nodes(1,:)==B)&(nodes(2,:)== G)&(nodes(3,:)==R));

% Just use the 'j' value for the index needed by 'mrManDist'
 curNode = j;      

% radius in mm - see above
[dist nPntsReached] = mrManDist(nodes,edges,curNode,dimdist,-1,radius);
unfList = find(dist > 0);
fprintf('Unfolding %4.0f points.\n',length(unfList))
    

% Define the sub-sampling (distance on the manifold ? ABP)
% This is in millimeters - use around 2 - 4 
sampSpacing = 3.5;

%% Variable initializations for the flattening (unfoldFlatten).
%
 % Set the total number of iterations.
 nIter = 9   % standard is 6

 % Set the number of iterations between saves of outputs in unfoldFlaten.
 writeInterval = 6;   

 % Set the maximum bias weight in favor of the sum of the 
 % square of the perpendicular distance of the points from
 % the "flattening" plane. You can think of this as the 
 % maximum "importance" of having the points as close as 
 % possible to the flattening plane relative to keeping the
 % inter-distance relationships the same as the manifold
 % istances stored in mDist. 
 flatWeight = 12;

 % Set number of neighbors used in finding the new position of
 % each point in the set of sample points.
 rSamp = 35;
 
 % Set the perpendicular to the flattening plane (thus defining the 
 % flattening plane).
 P = [-1 1 0] 


%%%%
