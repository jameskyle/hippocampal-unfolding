% resVis.m
% ------------
% 
% function resVis(paramsFile)
%
%  AUTHOR: Brian Wandell, Patrick Teo
%    DATE: March 1996
% PURPOSE: 
%      This function produces some graphical analyses of
%      the results of the unfolding algorithm. Currently it displays:
%          (a) an image that shows from which plane each point 
%              has come;
%          (b) a pseudo-color image that shows the relative distance  from the
%              startPoint to the other unfolded points in the plane.
%
%      This routine can be called after the results have been
%      calculated and saved. Use the same paramsFile that was used to
%      create the unfolding, via resVis(paramsFile).
%      
% ARGUMENTS: 
%      paramsFile : This is a string containing the name (without .m) 
%                   of the script file with all the initializations 
%                   of parameters and paths for loading raw input data 
%                   and saving out results.
%
% Modified: 12.16.96, BW, update for new Unfold storage.
% Modified:  8.10.96, BW, to create the errUnfold.tiff image
% Modified:  7.12.96, BW, to make tiff, rather than ps, output image 
% Modified:  2.26.97, BW & HB, to speed up error calculation by 
%                         limiting it to 1000 sample points
% Modified:  5.02.97, BW, for layer1, cuts, etc.
% Modified: 10.14.97, SC, Matlab 5.0 compatibility
% Modified: 10.23.97, SC, added error and penalty function plots
% Modified: 11.07.97, SC, eliminated duplicate distances and errors
% Modified: 02.09.98, SC, added ability to handle cut file
% Modified: 04.16.98, HB, fixed bug with removeNodes, since
%                         grayNodes and unfList are the same size
% Modified: 06.25.98 SJC, New resVis version that uses the paramsFile created by mrVol
%			  (so the unfList needs to be found by resVis).
% Modified: 08.20.98 HAB, Changed incorrect variable name "nodes" to "grayNodes"
% Modified: 10.13.98 SJC, Modified to work with version 4.0 of Unfold and to
%			  display only the depth and distance maps
% Modified: 12.15.98 SJC, Modified so that it only needs to be in the unfold
%			  directory and get the name of the parameters file
%			  as an input argument.
%	    3.05.03  PFR  created resVis4 from resVis, 
%			changed readgrayGraph to readgrayGraph4
%			changed gLocs3dfloat to gLocs3d
%			changed tiffwrite to imwrite
%


function resVis4(paramsFile)

%PFR added msg:
fprintf('\n\n resVis4 MSG:visualization routine to picture the flattened gray matter \n\n');

% Run the parameters file
%
eval(paramsFile);

% Load in the flat file
%
load flat

% Read in the gray matter file and keep only the unfolded nodes
%

% PFR replaced: [grayGraph.nodes, grayGraph.edges] = readGrayGraph(graphFile);
[grayGraph.nodes, grayGraph.edges] = readGrayGraph4(graphFile);

[grayGraph.nodes, grayGraph.edges] = keepNodes(grayGraph.nodes,grayGraph.edges,unfList);
grayGraph.dimdist = dimdist;

% Find the distance from the start point to each of the unfolded nodes
%
[dist nPntsReached] = mrManDist(grayGraph.nodes,grayGraph.edges,startPoint,...
 			grayGraph.dimdist,-1);

% Take a look where the points came from. Each color codes
% a different plane in the original data set. The (x,y) positions
% show the locations in the unfolded (flattened-out) representation.
%
sFactor = 1;

% Create a 8x8 gauss kernel with a standard deviation of 2. 
% If unfold region is small (radius < 30), make gauss kernel smaller (e.g. 4)
if (radius < 30)
  kernel = mkGaussKernel(4,2);
else
  kernel = mkGaussKernel(8,2);
end

% Define the colormap adding a gray color at the end of a 'hot' colormap.
mp = [hot(64); .5 .5 .5];

% Create the image which indicates the original plane origin of points. 
% First for gLocs2d
if ~isempty(gLocs2d)
  imUnfold2d = viewUnfold(gLocs2d,sFactor,kernel,mp,gLocs3d(:,3));
  h = figure; image(imUnfold2d), axis image; set(h,'Name','2D Depth Map');
  colormap(mp); colorbar('h')
% PFR  tiffwrite(imUnfold2d,mp,'imUnfold2d.tiff')
  imwrite(imUnfold2d,mp,'imUnfold2d.tiff')
end

% Now for gLocs3dfloat

% PFR set gLocs3dfloat  to gLocs3d 
% The previous version of resVis.m used a variable called gLocs3dfloat,
% but I believe it was a typo and should have been gLocs3d,  which is loaded in from flat.mat
%
gLocs3dfloat=gLocs3d;

if ~isempty(gLocs3dfloat)
  imUnfold3d = viewUnfold(gLocs3dfloat(:,1:2),sFactor,kernel,mp,gLocs3d(:,3));
  h = figure; image(imUnfold3d), axis image; set(h,'Name','3D Depth Map (displayed in 2D)');
  colormap(mp); colorbar('h');
% PFR  tiffwrite(imUnfold3d,mp,'imUnfold3d.tiff')
  imwrite(imUnfold3d,mp,'imUnfold3d.tiff');
end

%% Compute images that show the distance from the startPoint.

% Plot the graph showing the startPoint and the distance to the
% unfolded points in color.
% 
if ~isempty(gLocs2d)
  [imUnfold2d rowF colF] = viewUnfold(gLocs2d,sFactor,kernel,mp,dist');
  h = figure; image(imUnfold2d), axis image; set(h,'Name','2D Distance Map');
  colormap(mp); colorbar('h')

  % Plot the start point.
  % Subtracting one corrects for the 1:n version 0:(n-1) indexing
  % style, I think -- BW
  % 
  startIndex = find(dist == 0);
  hold on; plot(colF(startIndex),rowF(startIndex),'go')

  % Plot contours of equal distance from the start point.
  % Matlab 5.0 uses same colormap for all plots on same figure, so
  % the contour plots had to be made a different color to be seen
  hold on; contour(imUnfold2d,'k'); axis ij
  hold off

  % Saving images in tiff format
% PFR  tiffwrite(imUnfold2d,mp,'distMap2d.tiff')
  imwrite(imUnfold2d,mp,'distMap2d.tiff');

end

if ~isempty(gLocs3dfloat)
  [imUnfold3d rowF colF] = viewUnfold(gLocs3dfloat(:,1:2),sFactor,kernel,mp,dist');
  h = figure; image(imUnfold2d), axis image; set(h,'Name','3D Distance Map (displayed in 2D)');
  colormap(mp); colorbar('h')

  % Plot the start point.
  % Subtracting one corrects for the 1:n version 0:(n-1) indexing
  % style, I think -- BW
  % 
  hold on; plot(colF(startIndex),rowF(startIndex),'go')

  % Plot contours of equal distance from the start point.
  % Matlab 5.0 uses same colormap for all plots on same figure, so
  % the contour plots had to be made a different color to be seen
  hold on; contour(imUnfold3d,'k'); axis ij
  hold off

  % Saving images in tiff format
% PFR tiffwrite(imUnfold3d,mp,'distMap3d.tiff')
  imwrite(imUnfold3d,mp,'distMap3d.tiff');

end

return

%%%%
