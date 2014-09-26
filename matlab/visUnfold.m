% visUnfold.m
% ------------
% 
% function visUnfold(saveDir,errFlag)
%
% AUTHOR: Taken from resVis.m written by Brian Wandell, Patrick Teo
% DATE: March 1996
% PURPOSE: 
%      This function performs a graphical examination of
%      the results of the unfolding algorithm. Currently it displays:
%          (a) an image that shows from which plane each point 
%              has come;
%          (b) a graph of the total residual error against number 
%              of iterations.
%          (c) an image that shows the relative distance error
%              associated with each point in the graph.
%
%      Note that resVis can be called after the 
%      results have been calculated and saved. Use the
%      same paramsFile that was used to create the unfolding, via
%      resVis(paramsFile).
%
% ARGUMENTS: 
%      saveDir:	    Explicitly pass the directory in which
%                   the unfold output is placed.  Solves parameter
%         	    inheritance problems.  ABP, AZ
%      errFlag:     If additional error information has been saved
%                   then load the data and create the error images, too.
% DEPENDENCIES:
%      This functions requires these other functions:
%        (a) viewUnfold.m
%        (b) mrVcoord.m
%        (c) distanceMatrix.m
%        (d) mkGaussKernel.m
%
% Modified: 12.16.96, BW, update for new Unfold storage.
% Modified: 8.10.96, BW, to create the errUnfold.tiff image
% Modified: 7.12.96, BW, to make tiff, rather than ps, output image 
% Modified: 2.26.97, BW & HB, to speed up error calculation by 
%    limiting it to 1000 sample points
% Modified: 07.23.97, ABP Changed the calling parameters to resVis.m
%           since to my eye all it really needed was the directory
%           where the unfold information was saved.  Passing the 
%           name of the 'rightP.m' file and then executing it was
%           causing all kinds of problems.

function visUnfold(saveDir,errFlag)

% Get the current directory.
curDir = cd;

% Call the initialization script to initialize variables
% and paths for loading raw input data and saving out results. 
%

disp(['Getting values in directory: ',saveDir]);


% Load the files from Unfold.
%
 changeDir(saveDir);
 eval(['load flat'])
 fprintf('Loaded flat, containing %d points for gLocs2/3d\n',...
	size(gLocs2d,1));

% Take a look where the points came from. Each color codes
% a different plane in the original data set. The (x,y) positions
% show the locations in the unfolded (flattened-out) representation.
%
% Scale the image by two.
 sFactor = 1;

% Create a 8x8 gauss kernel with a standard deviation of 2. 
 kernel = mkGaussKernel(8,2);

% Define the colormap adding a gray color at the end of a 'hot' colormap.
 mp = [hot(64); .5 .5 .5];

% Create the image which indicates the original plane origin of points. 
 imUnfold = viewUnfold(gLocs2d,sFactor,kernel,mp,gLocs3d(:,3));

% Display image.
 h = figure; image(imUnfold), axis image; set(h,'Name','Depth Map');
 colormap(mp);
 colorbar('h')

% Save the image in tiff format.  If the tiff works out,
% just use it.
%
fname = 'imUnfold.tiff';
tiffwrite(imUnfold,mp,fname)

if(errFlag)
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
    boo = sprintf('%4.0f sampLocsF points.  Using only 1000\n',n);
    disp(boo)
  end

% Plot the total residual error against the number of iterations.
% Remember that the distance matrix is symmetric, so to count the
% distances we divide by 2.

 nSampPoints = size(sampLocsF,1);
 fprintf('Building distance matrix for %d sampLocsF points\n',nSampPoints);

 sampDist = distanceMatrix(sampLocsF);
 fprintf('Number of sample distances:  %d\n',prod(size(sampDist))/2);
 err = sampDist(:) - mDist(:);
% Now, we make a few plots that include calculating the value of
% the 90th error percentile.
% 
 pValue = 90;

% This graph is a histogram of the sample point inter-distance errors
 h = figure;  set(h,'Name','Distance Errors');
 subplot(2,1,1)
 hist(err,[-30:3:30]); 
 title('Inter sample point distance errors (mm)')

% This graph plots the size of the 90th percentile error for each
% of the sample points
subplot(2,1,2)
percentiles = zeros(1, nSampPoints);
for i=1:nSampPoints
  percentiles(i) = prctile(abs(err(i,:)),pValue);
end
hist(percentiles,[-20:5:20])
title(sprintf('%3.0f percentile error histogram',pValue));
fprintf('Std Dev of distances errors: 	%f\n', std(sampDist(:) - mDist(:)));
fprintf('%3.0f Error percentile: %f\n', ...
    pValue, prctile(sampDist(:) - mDist(:),pValue));

% Save the histogram line drawing in a postscript format.
%
fname = 'errUnfold.eps'
eval(['print -deps ',fname]);

% Compute an image that shows the relative distance error
% of various points
%
mp = [hot(64); .5 .5 .5];
err = reshape(err,nSampPoints, nSampPoints);
dErr = prctile(abs(err),pValue);

% Now, we find the sample positions with respect to the unfList
%
 if (~exist('unfList'))
   fprintf('No unfList in parameter file.  Assuming complete unfold.\n');
   unfList = [1:size(gLocs2d,1)];
 else	   
   fprintf('Read in unfList.\n');
 end

% sampUnfList = zeros(1,length(xSampGray));
% count = 1;
% for ii = xSampGray
%   sampUnfList(count) = find(unfList == ii);
%   count = count+1;
% end

%  errUnfold = viewUnfold(gLocs2d(sampUnfList,:),sFactor,kernel,mp,dErr','s');
 errUnfold = viewUnfold(gLocs2d(xSampGray,:),sFactor,kernel,mp,dErr','s');
 h = figure; image(errUnfold), axis image; set(h,'Name','Error Map');
 title(sprintf('%3.0f percentile error map',pValue));
 colormap(mp); 
 barHandle = colorbar('h');
 set(barHandle,'xtick',[0:10:60],'xticklabels',[0:10:60]*max(dErr)/60);
 fname = 'errUnfold.tiff'
 tiffwrite(errUnfold,mp,fname)
end

% Go back to the original directory
 changeDir(curDir)

