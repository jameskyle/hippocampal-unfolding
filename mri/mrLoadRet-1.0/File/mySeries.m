function [imageSeries,newSize]=mySeries(dir,imageList,originalSize,crop,header)
%
%  [imageSeries newSize] = mySeries(dir,imageList,originalSize, :crop, :header)
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
%
%
%	Make sure the arguments are sensibly arrange
%
if nargin < 5, header = -1; end
if nargin < 4, crop = []; end
if nargin < 3  error('mrSeries requires three arguments'); end

nImages = length(imageList);
if nImages < 1
  error('Bad image imageList')
end

%Name = zeros(nImages,size(dir,2)+6);
j = 1;
for i = imageList
  Name(j,:) = sprintf('%s/I.%03d',dir,i);  
  j = j + 1; 
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
 if (~check4File(Name(i,:)))
	error(['*** Error: Cannot find file ',Name(i,:)]);
 end
 if cropFlag == 1
   tmp = myRead(Name(i,:),originalSize,header);
   [tmp newSize] = cropImage(tmp,originalSize,crop);
   imageSeries(i,:) = reshape(tmp,1,prod(newSize));
 else
  imageSeries(i,:) = myRead(Name(i,:),originalSize,header);
 end
  disp(sprintf('I.%03d',i));  
% disp(Name(i,:))
end 





