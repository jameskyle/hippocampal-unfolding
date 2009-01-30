% resVis.m
% ------------
% 
% function resVis(paramsFile,errFlag)
%
%  AUTHOR: Brian Wandell, Patrick Teo
%    DATE: March 1996
% PURPOSE: 
%      This function produces some graphical analyses of
%      the results of the unfolding algorithm. Currently it displays:
%          (a) an image that shows from which plane each point 
%              has come;
%          (b) a graph of the total residual error against number 
%              of iterations.
%          (c) a pseudo-color image that shows the relative distance  from the
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
%      errFlag:     If additional error information has been saved
%                   then load those data and create the error images, too.
%
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

function resVis(paramsFile,errFlag)

% Debugging
% paramsFile = 'leftP041598';
% errFlag = 1;
% unfSaveDir = '/usr/local/mri/anatomy/tyler/left/unfold/041598';

% Get the current directory.
curDir = cd;

% Call the initialization script to initialize variables
% and paths for loading raw input data and saving out results. 
%
eval(paramsFile)
 % Load raw data 
 [grayNodes grayEdges] = readGrayGraph(graphFile);

 if (size(startPoint,2) == 3)
   [i,j] = find((nodes(1,:)==startPoint(1,3)) & (nodes(2,:)==startPoint(1,2)) & (nodes(3,:)==startPoint(1,1)));
   startPoint = j;
 end

 [dist nPntsReached] = mrManDist(grayNodes,grayEdges,startPoint,dimdist,-1,radius);
 unfList = find(dist >= 0);
 startPoint = find(unfList == startPoint);
 
 [grayNodes,grayEdges] = keepNodes(grayNodes,grayEdges,unfList);
 numGrayNodes = size(grayNodes,2)

% Load the files from Unfold.
%
changeDir(unfSaveDir);
eval(['load flat'])
fprintf('Loaded flat, containing %d points for gLocs2/3d\n',size(gLocs2d,1));

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
imUnfold = viewUnfold(gLocs2d,sFactor,kernel,mp,gLocs3d(:,3));

% Display image.
h = figure; image(imUnfold), axis image; set(h,'Name','Depth Map');
colormap(mp); colorbar('h')

% Save the image in tiff format.  If the tiff works out,
% just use it.
%
fname = 'imUnfold.tiff';
tiffwrite(imUnfold,mp,fname)

if(errFlag == 1)

  fprintf('Loading dist and sampLocsF for error calculations.\n');  
  eval(['load dist'])
  eval(['load sampLocsF'])
  clear dSampNeighbors

  % If there are more than 1000 sample points, subsample 1000 of them
  % just for the error calculation to speed things up
  % 
  n = size(sampLocsF,1)
  if n > 1000
    subsamp = round(1:n/1000:n);
    sampLocsF = sampLocsF(subsamp,:);
    xSampGray = xSampGray(:,subsamp);
    mDist = mDist(subsamp,subsamp);
    fprintf('%4.0f sampLocsF points.  Using only 1000\n',n);
  end

  % Plot the total residual error against the number of iterations.
  % Remember that the distance matrix is symmetric, so to count the
  % distances we divide by 2.

  nSampPoints = size(sampLocsF,1);
  fprintf('Building distance matrix for %d sampLocsF points\n',nSampPoints);
  sampDist = distanceMatrix(sampLocsF);

  % Eliminate duplicate distance errors.  All errors in error matrix above
  % the main diagonal are duplicates of errors below the main diagonal and
  % would be counted twice if not eliminated.
  n = size(sampLocsF,1);
  duplErrs = [];
  for i = 1 : (n-1)
    duplErrs = [ duplErrs, (i*n)+1 : (i*n)+i ];
  end;
  sampDist(duplErrs) = [];
  mDist(duplErrs) = [];

  fprintf('Approx. number of sample distances: %3.0f\n', ...
      round(length(sampDist(:))));
  err = sampDist(:) - mDist(:);
  
  % Weigh errors by the selected penalty function
  switch penalty
    case 2,
      pfunc_err = err.^2;
    case 3,
      pfunc_err = log( 1 + abs(err) );
    case 4,
      pfunc_err = 1 - (0.5).^abs(err);
    case 5,
      pfunc_err = 1 - ( mDist(:) ./ sampDist(:) );
    case 6,
      pfunc_err = abs(err) ./ ( M*ones(size(err)) + mDist(:) );
    otherwise,
      pfunc_err = abs(err);
  end;

  save errors mDist err pfunc_err

  % Calculate the mean and variance of both errors
  [ decimated_mDist, mean_err, var_err ] = running_avg( abs(err), mDist, 100 );
  std_dev_err = sqrt(var_err);

  [ decimated_mDist, mean_perr, var_perr ] = running_avg( pfunc_err, mDist, 100 );
  std_dev_perr = sqrt(var_perr);

  % Plot errors with means and standard deviations
  h = figure; set(h,'Name','Error vs. Distance in the Manifold');
  subplot(2,1,1)
  plot(mDist(:),abs(err(:)),'.')
  xlabel('dm')
  ylabel('|dp - dm|')
  v1 = axis;
  
  subplot(2,1,2)
  plot(mDist(:),pfunc_err(:),'.')
  xlabel('dm')
  ylabel('Penalty Function')
  v2 = axis;
   
  % Plot means plus and minus one standard deviation 
  h = figure; set(h,'Name','Means and Standard Deviations of Error'); 
  subplot(2,1,1)
  hold on
  plot(decimated_mDist,mean_err,'k')
  plot(decimated_mDist,mean_err + std_dev_err,'g')
  plot(decimated_mDist,mean_err - std_dev_err,'g')
  axis(v1)
  xlabel('dm')
  title('Error Mean and 1 Std. Dev.')
  hold off
  
  subplot(2,1,2)
  hold on
  plot(decimated_mDist,mean_perr,'k')
  plot(decimated_mDist,mean_perr + std_dev_perr,'g')
  plot(decimated_mDist,mean_perr - std_dev_perr,'g')
  axis(v2)
  xlabel('dm')
  title('Penalty Function Error Mean and 1 Std. Dev.')
  hold off

  h = figure; set(h,'Name','Distance Errors');

  % Now, we make a few plots that include calculating the value of
  % the 90th error percentile.
  % 
  pValue = 90;

  % This graph is a histogram of the sample point inter-distance errors
  subplot(2,1,1)
  hist(err,[-1:.2:1]*max(abs(err(:)))); 
  title('Inter sample point distance errors (mm)')

  % This graph plots the size of the 90th percentile error for each
  % of the sample points
  subplot(2,1,2)
  percentiles = zeros(1, nSampPoints);
  for i=1:nSampPoints
    percentiles(i) = prctile(abs(err(i,:)),pValue);
  end
  hist(percentiles,[0:0.1:1]*max(abs(percentiles(:))))
  title(sprintf('%3.0f percentile error histogram',pValue));

  fprintf('Std Dev of distances errors: %f\n', ...
      std(sampDist(:) - mDist(:)));
  fprintf('%3.0f Error percentile: %f\n', ...
      pValue, prctile(sampDist(:) - mDist(:),pValue));

  % Save the histogram line drawing in a postscript format.
  % 
  fname = 'errUnfold.eps'
  eval(['print -deps ',fname]);
end

% Compute images that show the distance from a couple of seed
% points, and in particular the startPoint.

% Load raw data if grayNodes and grayEdges do not exist
% Otherwise, use grayNodes and grayEdges from params file
%
if (~exist('grayNodes') | ~exist('grayEdges'))
  fprintf('Loading gray graph file: %s.\n',graphFile);
  [grayNodes grayEdges] = readGrayGraph(graphFile);
end
numGrayNodes = size(grayNodes,2)

if (~exist('unfList'))
  fprintf('No unfList in parameter file.  Assuming complete unfold.\n');
  unfList = [1:size(gLocs2d,1)];
elseif numGrayNodes ~= size(unfList,2)
  fprintf('Removing nodes not in unfList.\n');
  % Make the nodes and edges graph that was unfolded
  % 
  [grayNodes,grayEdges] = keepNodes(grayNodes,grayEdges,unfList);
  numGrayNodes = size(grayNodes,2);
end

if (exist('CutFile'))
  fprintf('Loading cutfile: %s\n',cutFile');
  cmd = ['load ',cutFile]; eval(cmd);
  [nodes1,edges1] = removeNodes(grayNodes,grayEdges,cutNodes);
end

% Find the distance from the startPoint to each of the unfolded points
% 
dist = mrManDist(grayNodes,grayEdges,startPoint,dimdist,-1,3*radius);

% Plot the graph showing the startPoint and the distance to the
% unfolded points in color.  There appears to be a problem here
% in finding the location of the center.  Is this an issue for
% mrLoadRet? 
% 

[imUnfold rowF colF] = viewUnfold(gLocs2d,sFactor,kernel,mp,dist');
h = figure; image(imUnfold), axis image; set(h,'Name','Distance Map');
colormap(mp); colorbar('h')

startIndex = find(dist == 0);

% Saving image in tiff format
fname = 'distMap.tiff';
tiffwrite(imUnfold,mp,fname)
% Subtracting one corrects for the 1:n version 0:(n-1) indexing
% style, I think -- BW
% 
hold on; plot(colF(startIndex)-1,rowF(startIndex)-1,'go')

% Matlab 5.0 uses same colormap for all plots on same figure, so
% the contour plots had to be made a different color to be seen
hold on; contour(imUnfold,'k'); axis ij
hold off


% Go back to the original directory
% 
changeDir(curDir)

%%%%
