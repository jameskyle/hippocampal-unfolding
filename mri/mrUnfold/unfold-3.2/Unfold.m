% SCRIPT
% 
% Unfold.m
% -------
%
% version 3.2
%
% SCRIPT
%
%  AUTHOR: Brian Wandell, Athos Georghiades, Patrick Teo
%    DATE: March, 1996
% PURPOSE: 
%          This is a function manages calls to the 
%          unfolding code. It calls the main routines:
%            (a) unfoldDist.m  : This sub-samples the volume and creates
%                                several distance and index matrices used
%                                in the flattening and interpolating steps.
%            (b) unfoldFlatten.m: Performs the incremental flattening  
%                                (or unfolding) of the sampled gray points 
%                                supplied by unfoldDist.
%            (c) unfoldInterp.m: Interpolates all the layer 1
%                                gray points to positions among
%                                the sample points.
%            (d) unfoldSqueeze.m: Places all thelayer 2+
%                                gray points to the position of
%                                the closest layer1 point.
%
%
% ARGUMENTS:
%   
% pFile : This is a string containing the name (without .m) 
%   of the script file with all the initializations 
%   of parameters and paths for loading raw input data 
%   and saving out results. The script file can be 
%   edited to suit the needs of a specific run. 
%   This file sets the values of the parameters:
% 
% ------------------------------------------------------------------
%	P		dimdist		flatWeight
%	unfSaveDir	nIter		rSamp
%	graphFile       sampSpacing	penalty_num
%	unfList         cutFile		M
% ------------------------------------------------------------------
%
% vis : This is a flag. When set equal to 1 then a
%   visualization of the results is performed by 
%   calling the function resultsVis.
%   
% saveFlag: Decide whether to save (1) or not (0) the auxiliary files:
%   dist, sampLocsF.  If these are NOT saved, then
%   only a fraction of the resVis results can be run.
%   The error histograms are not computed.  Flat.mat is always saved.
%
%
% MODIFICATIONS:
% 3.31.97   HB Added variables from paramsFile to be saved in flat.mat.
% 5.01.97   BW Started update for cuts and pure first layer unfolding
% 10.13.97  SC Modified function for Matlab 5.0
% 10.14.97  SC Added penalty function selection variable.  It should be
%	       specified in paramsFile
% 10.17.97  SC Added parameter M for penalty function, only needed for
%              penalty function 6
% 04.02.98  SJC, ABP Added grayNodes and grayEdges to be saved in flat.mat
% 04.03.98  SJC, ABP Added code that creates the layer1map and saves it in flat.mat
% 05.28.98  SJC Made modifications of code to read params file generated by
%		mrUnfoldGUI
%		(unfList is now calculated by Unfold instead of the params file)
% 06.25.98  SJC Changed version of resVis to read in the params file generated
%		by the mrUnfoldGUI
% 06.26.98  SJC Made the random number seed (used by selectNeighbors.m) a
%		parameter that can be set in the params file.
% 07.06.98  SJC Eliminated writeInterval from the parameters list.  It was not used.
% 07.08.98  SJC Eliminated duplicate saving of the parameters file
% 07.14.98  SJC Created new version of Unfold, version 3.2
%		New version cannot read in parameters files from older versions
%		of Unfold; it can only read in parameters files created by 
%		mrUnfoldGUI
%

% DEBUGGING
% cd '/usr/local/matlab/toolbox/stanford/mri/unfold-3.1/Example'
% pFile = 'GraphP'
% vis = 1;
% saveFlag = 1;

if ( ~exist('pFile') )
  error('No paramsFile name defined.  Exiting Unfold.m script')
end

 if ( ~exist('saveFlag') ),   saveFlag = 0;  end
 if (~exist('vis')),   vis = 1; end

% Get the current directory.
 curDir = cd;

% Call the initialization script to initialize variables
% and paths for loading raw input data and saving out results. 

 fprintf('Running the paramsFile\n');
 eval(pFile)

% 07.08.98 SJC
% The params file is already saved out when the unfold is started
% from mrVol (soon to be renamed mrUnfold)
% fprintf('Copying paramsFile to save directory');
% cmd = sprintf('cp %s.m %s/paramsFile.m',pFile,unfSaveDir)
% unix(cmd)

 % Load raw data 
 fprintf('Loading gray graph file: %s.\n',graphFile);
 [grayNodes grayEdges] = readGrayGraph(graphFile);

 if (size(startPoint,2) == 3)
   [i,j] = find((nodes(1,:)==startPoint(1,3)) & (nodes(2,:)==startPoint(1,2)) & (nodes(3,:)==startPoint(1,1)));
   startPoint = j;
 end

 [dist nPntsReached] = mrManDist(grayNodes,grayEdges,startPoint,dimdist,-1,radius);
 unfList = find(dist >= 0);
 startPoint = find(unfList == startPoint);
 fprintf('Unfolding %4.0d points; %2.0f mm from occipital pole.\n', length(unfList), radius);
 
 [grayNodes,grayEdges] = keepNodes(grayNodes,grayEdges,unfList);
 numGrayNodes = size(grayNodes,2)
 
 checkGraySymmetry(grayNodes,grayEdges);
 checkGrayContinuity(grayNodes,grayEdges,dimdist);
   
 % The unfold takes place for the first layer.  We identify the
 % first layer points and use them for the initial flattening.  We
 % squeeze down the points in the other layers after the first
 % layer is unfolded.
 % Represents which layer every gray node is in
 layer = grayNodes(6,:);
 layer1 = find(layer == 1);
 
 if (length(layer1) < size(grayNodes,2))
   [nodes1,edges1] = keepNodes(grayNodes,grayEdges,layer1);
 else
   % grayNodes only contains first layer nodes, no need to select them
   nodes1 = grayNodes;
   edges1 = grayEdges;
 end
 numNodes1 = size(nodes1,2)

% if exist('cutFile')
%   fprintf('Loading cutfile: %s\n',cutFile');
%   cmd = ['load ',cutFile]; eval(cmd);
%   [nodes1,edges1] = removeNodes(nodes1,edges1,cutNodes);
%   checkGrayContinuity(nodes1,edges1,dimdist);
% end

 % unfoldDist performs three calculations
 % 1. Subsamples the gray matter volume
 % 2. Calculates the geodesic distances along the manifold
 % between each sample point all the other sample points (mDist)
 % 3. Calculates the distance between each sample points and a set of
 % neighboring inter-sample points
 % (Type help unfoldDist for more details).
 % 
 fprintf('Calling unfoldDist ...\n');
 [mDist, dSampNeighbors, xSampNeighbors, xSampGray] ...
     = unfoldDist(nodes1, edges1, sampSpacing, dimdist);

 %DEBUG: To see the locations of the original gray nodes, take a
 %look at this figure
 % xgobi(grayNodes(1:3,xSampGray)')

 % Save the data returned by unfoldDist.  You can start by loading
 % just these data if you want to debug the next level
 % 
 if(saveFlag == 1)
  fprintf(' -> Saving mdist and other stuff\n');
  comment = 'These values and indices refer to the layer1 nodes only';
  outData = ' mDist dSampNeighbors xSampNeighbors xSampGray comment';
  changeDir(unfSaveDir); 
  cmd = ['save dist ', outData]
  eval(cmd)
  changeDir(curDir);  
  size(mDist)
 end

 % Calculate sampLocsF.  
 % These are 3d positions of the sample points that (a) maintain the
 % distances in the gray matter and (b) are near a plane.
 % 
 fprintf('Flattening...\n');

 % Initialize the 3d locations of the gray matter points
 sampLocsF = alignPoints(nodes1([1:3],xSampGray)','c');

 % Move them around in 3 space until they are kind of flat
 [sampLocsF err] = unfoldFlatten(mDist, sampLocsF, ...
     flatWeight, rSamp,P, sampSpacing, unfSaveDir, nIter, penalty, M, rSeed);

 %DEBUG:  To see how close you are to a plane and look for
 %uniformity of the sample positions, do this
 %xgobi(sampLocsF)

 % It is big, it is already saved, so get rid of it 
 % 
 clear mDist

 fprintf('Initializing layer 1 positions:  gLocs2dL1\n');
 gLocs2dL1 = zeros(numNodes1,2);

 % Project locs (the 3d sample locations computed by
 % unfoldFlatten) down to their 2d planar locations.
 [u s v] = svd(P);
 sampLocs2d = sampLocsF*v(:,[2,3]);
 gLocs2dL1(xSampGray,:) = sampLocs2d;
 perpErr = sampLocsF*v(:,1);
  
 if(saveFlag == 1)
  fprintf(' -> Saving sampLocsF\n');
  comment = 'These indices are all with respect to layer 1';
  changeDir(unfSaveDir); 
  outData = ' sampLocsF err perpErr comment ';
  cmd = ['save sampLocsF ', outData]
  eval(cmd)
  changeDir(curDir);
 end

 % DEBUGGING
 % plot(sampLocs2d(:,1),sampLocs2d(:,2),'ro'); hold on

 % At present, the sampLocs2d are not interpolated.  Maybe we
 % should have them be repositioned, too.
 gLocs2dL1 = unfoldInterp(sampLocs2d, gLocs2dL1, ...
     dSampNeighbors, xSampNeighbors, xSampGray, penalty, M);

 comment = 'Temporary store of layer 1 gLocs2d. ';
 changeDir(unfSaveDir);
 save gLocs2dTmp gLocs2dL1 comment
 changeDir(curDir);
 
 % Now, create the full array for gLocs2d and place the layer1
 % coordinates into the proper index.
 gLocs2d = zeros(numGrayNodes,2);
 gLocs2d(layer1,:) = gLocs2dL1;
 
 % Now, squeeze the layer two and beyond points onto the
 % position of the closest layer 1 point.
 fprintf('Positioning layer 2+ points with unfoldSqueeze.\n');

 % Finally, we make the indices go all the way to the gray matter
 % This represents the layer 1 points in the unfold list 
 squeezeList = find(layer > 1);

 fprintf('Squeeze list has %4.0f points\n',length(squeezeList));
 gLocs2d = unfoldSqueeze(sampLocs2d, gLocs2d, ...
     grayNodes, grayEdges, layer, sampSpacing, dimdist, ...
     squeezeList);

% DEBUGGING
% plot(sampLocs2d(:,1),sampLocs2d(:,2),'ro'); hold on
% plot(gLocs2d(layer1,1),gLocs2d(layer1,2),'y.'); hold on
% plot(gLocs2d(squeezeList,1), gLocs2d(squeezeList,2),'cx'); 
% axis equal, axis square, hold off

 fprintf('Saving gLocs2d and gLocs3d in flat.mat.\n');
 gLocs3d = grayNodes([1:3],:)';
 
 % Make layer1map here?  Add it to be saved in flat.mat
 % 'layer1map' is a vector of the closest layer 1 node to each
 % gray matter node.  It may be used for rendering purposes.
 %layer1map = squeeze2layer1(grayNodes,grayEdges,unfList,dimdist);
 
 % Save the flat.mat file and get rid of gLocs2dTmp
 % 
 changeDir(unfSaveDir);
 outData = [' gLocs2d gLocs3d pFile graphFile'];
 %outData = [outData,' layer1map'];
 outData = [outData,' grayNodes grayEdges unfList'];
 outData = [outData,' sampLocsF xSampGray'];
 outData = [outData,' startPoint unfSaveDir dimdist'];
 outData = [outData,' radius sampSpacing nIter'];
 outData = [outData,' flatWeight rSamp P '];

 cmd = ['save flat ', outData]
 eval(cmd)
 unix('rm -f gLocs2dTmp.mat');
 changeDir(curDir);

 %  There have been problems creating distanceMatrix in resVis,
 %  because of memory limits.  So, I clear out variables here 
 %  before calling resVis. The variables pFile, saveFlag, and
 %  gLocs2/3d must be preserved. The other parameters can go.

  clear dSampNeighbors xSampNeighbors grayNodes grayEdges

 % Graphical examination or results visualization:
 % In order to visualize the results one can use graphical routines
 % in the function called below. Currently the function resultsVis
 % displays:
 % (b) a graph of the total residual error against number of iterations. 
 % (a) an image that shows from which plane each point has come from;   

 if vis==1,
   fprintf('Running the visualization routine\n');

   % Only compute histograms if the saveFlag was set so that the
   % relevant data sets exist on disk.
   resVis(pFile,saveFlag);
 end

 return;

%%%%
