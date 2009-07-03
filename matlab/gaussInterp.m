% gaussInterp.m
% -------------
%
% function imInterp = gaussInterp(imUnfold, imValid, kernel, noDataVal)
%
%
% AUTHORS: S. Engel, B. Wandell
%    DATE: December 9, 1995
% PURPOSE: 
%          Interpolate values in an unfolded (flattened) image using 
%          gaussian weighted interpolation. The neighbors surrounding 
%          each location are averaged together using a guassian weighting 
%          kernel which is a function of the distance of the location of 
%          the neighbor from the center of the kernel (or to the location
%          that is being interpolated).
%
% ARGUMENTS:  
%          imUnfold : Image to be interpolated.
%           imValid : Binary image, with 1's specifying location of 
%                     valid data points in imUnfold.
%            kernel : 2-D gaussian filter used to do the interpolation.
%         noDataVal : Value placed at image locations where no valid data
%                     falls within the gaussian window. If noDataVal is not  
%                     passed then it is set to NaN.
%   interpCriterion : How much of the Gaussian must contain data before it
%                     is interpolated.
%
% MODIFICATIONS:
% 10.16.97 SC, added interpCriterion as an input parameter
%

function imInterp = gaussInterp(imUnfold, imValid, kernel, ...
				noDataVal, interpCriterion)


%% If noDataVal is not passed then set it to NaN.
%
if (nargin < 5), interpCriterion = 0.15;
if (nargin < 4), noDataVal = NaN; end
end

%% Set up total of weights by convolving the binary image with the kernel.
%
 imValidSmooth = conv2(imValid,kernel,'same');

%% Fill in invalid data (in imUnfold) with zeros so they do not contribute 
%% to the interpolation.
%
 imUnfold(~imValid) = zeros(1,sum(sum((~imValid))));


%% Blur imUnfold by convolving with the kernel.
%
 imInterp = conv2(imUnfold,kernel,'same');
 
  % DEBUGGING
  % mp = [hot(64); .5 .5 .5];
  % h = figure; image(4*imInterp), axis image; set(h,'Name','Distance Map after Interpolation, no weighing');
  % colormap(mp); colorbar('h');
  % hold on;
  % plot(10,13,'go');
  % hold off;


%% Divide out weights...
%

%only divide where pixels have positive weights
%to avoid annoying 'Warning: Divide by zero' message

goodVals = imValidSmooth>interpCriterion;

  % DEBUGGING
  % mp = [hot(64); .5 .5 .5];
  % h = figure; image(60*imValidSmooth), axis image; set(h,'Name','imBinary * kernel');
  % colormap(mp);
   
if sum(sum(goodVals))>0
  imInterp(goodVals) = imInterp(goodVals) ./ imValidSmooth(goodVals);
end

if sum(sum(~goodVals))>0
  imInterp(~goodVals) = NaN*ones(size(find(~goodVals)));
end


%% Fill in invalid interps by substituting to noDataVal.
%
 noData = (imValidSmooth == 0);
 imInterp(noData) = noDataVal*ones(1,sum(sum(noData)));

  % DEBUGGING
  % mp = [hot(64); .5 .5 .5];
  % h = figure; image(3*imInterp), axis image; set(h,'Name','Distance Map after Interpolation, with weighing');
  % colormap(mp); colorbar('h');
  % hold on;
  % plot(10,13,'go');
  % hold off;

%%%%










