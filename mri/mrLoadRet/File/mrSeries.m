function [imageSeries,newSize]=mrSeries(dir,imageList,originalSize,crop,header,prefix)
%
%  [imageSeries newSize] = mrSeries(dir,imageList,originalSize, :crop, :header,(prefix))
%
%  Read a series of mr images into the rows of the matrix imageSeries.
%  The size of the returned images is returned in newSize.
%
%	dir  -- a string containing the directory with the files
%	imageList -- a vector of numbers identifying the file numbers I.XXX
%	originalSize -- a vector containing the x and y dimensions
%		of the input image
%	crop --  an optional 2x2 matrix used to crop before returning
%	header -- an optional single number.  When set to 1 means
%		the file has a 7900 byte header.
%
%	prefix -- a string containing the prefix name of the image files.
%		the default is 'I', as in 'I.001'.  The user can supply
%	        a name such as 'P20482' to calculate time series directly
%		from reconstructed P files.
%
%
if nargin < 5, header = -1; end
if nargin < 4, crop = []; end
if nargin < 3,  error('mrSeries requires three arguments'); end

if nargin < 6, prefix='I'; end
 
nImages = length(imageList);
if nImages < 1
  error('Bad image imageList')
end

if isempty(crop) %cropping since null
 cropFlag = 0;
 newSize = originalSize;
else
 disp('Cropping the images')
 cropFlag = 1;
 cropmin = min(crop);
 cropmax = max(crop);
 newSize = cropmax - cropmin + 1;
end

%
imageSeries = zeros(nImages,prod(newSize));
%
for i = 1:nImages
 if cropFlag == 1
   tSeriesName = sprintf('%s/%s.%03d',dir,prefix,imageList(i));  
   tmp = mrRead(tSeriesName,originalSize,header);
   [tmp newSize] = cropImage(tmp,originalSize,crop);
   imageSeries(i,:) = reshape(tmp,1,prod(newSize));
 else
   tSeriesName = sprintf('%s/%s.%03d',dir,prefix,imageList(i));  
  imageSeries(i,:) = mrRead(tSeriesName,originalSize,header);
 end
 disp(tSeriesName)
end 
