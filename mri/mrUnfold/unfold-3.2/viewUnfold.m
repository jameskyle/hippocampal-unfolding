% viewUnfold.m
% ------------
%
% function [imUnfold rowF colF fSize] = viewUnfold(locs2d,sFactor,kernel,...
%	mp,cValues,mpScale);
%
%
%  AUTHOR: Brian Wandell
%    DATE: Nov. 23, 1995
% PURPOSE: 
%  Create a pseudo-color image of the unfolded representation.
% Each point is colored according to the data in mp and cValues.
% Image points without a gray-matter pixel are set to the
% value of the last entry in the color map, mp.
%
% If cValues is a vector, then its entries are taken to be
% indices into the color map, mp.  To code according to
% the original position, in 3d, of the point set
%	cValues = gLocs3d(:,3);
%
% The size of the returned image is sFactor*[r c], 
% where r and c are the row and column dimensions respectively 
% needed to accomodate the points in locs2d.
% The image is extrapolated smoothly using a kernel function.
% Points where no extrapolation reaches are colored with the 
% last color in the color map (size(mp,1)).
%
% Warnings about divided by zero are normal because of the 
% extrapolation procedure used here.
%
% ARGUMENTS:
%
% locs2d: Flattened locations. Size is n x 2
% sFactor: Scale factor used in mapping the flattened points 
%		onto the image plane. (Default = 2)
% kernel: Blurring kernel used for interpolating the image.
%		(Default = mkGaussKernel(8,2))
% mp : Color map for rendering the image 
%		(Default = [hot(64); .5 .5 .5];
% cValues : Index color map values to use.
% mpScale:  A flag to turn off image scaling.
%		(Default = 's', scaling on).
% interpCriterion: Value sent to gaussInterp defining how much data
%		   has to be within the Gaussian window before interpolating
%
% RETURNS:
%
% imUnfold: A colour image in which the color describe the 
%		original plane for each point in the unfolded 
%               representation.
% rowF,colF: The row and column positions of each of the
%            gray-matter points in the image.  These values are
%            used by mrLoadRet:mrCreateGray2Image routines
%
% fSize:     Size of flattened image
%
% DEPENDENCIES: 
%         This function requires these other functions:
%          (a) scale.m
%          (b) gridImage.m
%          (c) gaussInterp.m
%          (d) replaceValue.m
%
%Last Modified/9/26 -- GMB,BW,
% Modified 10.16.97 SC added interpCriterion

function [imUnfold,rowF,colF,fSize] = ...
   viewUnfold(locs2d, sFactor, kernel, mp, cValues, mpScale, interpCriterion)

%% Manage input arguments and defaults
%
if nargin < 7, interpCriterion = 0.15; end
if nargin < 6, mpScale = 's';  end
if nargin < 5, cValues = locs2d(:,1); end
if nargin < 4, mp = [hot(64); .5 .5 .5]; end
if nargin < 3, kernel = mkGaussKernel(8,2); end
if nargin < 2, sFactor = 2; end

if(size(cValues,1) ~= size(locs2d,1))
  error('viewUnfold:  cValues not same length as locs2d')
end


%% Change the values
%% in locs2d that are NaN to a value that is distinct from all
%% the other valid positions.
%
 nanLocs = isnan(locs2d(:,1));
 minXY = min(locs2d(find(~nanLocs),:));
 locs2d(find(nanLocs),:) = ...
	ones(length(find(nanLocs)),1)*(minXY-[5,5]);

 [imUnfold, rowF, colF] = gridImage(sFactor, locs2d, cValues, NaN);
 fSize = [max(rowF),max(colF)];

  % DEBUGGING
  % mp = [hot(64); .5 .5 .5];
  % h = figure; image(3*imUnfold), axis image; set(h,'Name','Distance Map before Interpolation');
  % colormap(mp); colorbar('h');
  % hold on;
  % plot(colF(59),rowF(59),'go');
  % hold off;

%% Interpolate.
%
 imBinary = imUnfold > 0;
 imUnfold = gaussInterp(imUnfold, imBinary, kernel, NaN, interpCriterion);


%% Locations that contain NaNs after the smoothing are
%% set to the last entry of the color map at those locations.
%
 % Get the number of colors in the colomap.
 nColors = size(mp,1);

 % Find where there are invalid interpolations. 
 l = isnan(imUnfold);

 % Scale valid interpolations.
 if (mpScale == 's')
   imUnfold(~l) = scale(imUnfold(~l), 1, nColors-1);
 end

 % Replace invalid interpolation values. 
 imUnfold = replaceValue(imUnfold,NaN,nColors);

 % This should have integer values, right?
 imUnfold = round(imUnfold);

%%%%
