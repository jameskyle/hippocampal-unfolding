function blurSeries = mrBlurTimeSeries(tSeries,curSize,kernSupport,kernStd)
%
%   blurSeries = mrBlurTimeSeries(tSeries,kernSupport,kernStd)
%
%PURPOSE:
%	Make a spatially blurred version of the time series data
%
%	tSeries: contains the image data in the columns
%       curSize:  The row and columns sizes of the image data
%
%	kernSupport (optional), kernStd (optional)
%	 These variables are passed to mkGaussKernel
%	 to create the blurring kernel. If they are not passed the
%	 default is [5 5] and [1.5 1.5].
%
%AUTHOR:  Engel, Wandell
%
if nargin == 4
  kernel = mkGaussKernel(kernSupport,kernStd);
else
  kernel = mkGaussKernel([5 5],[1.5 1.5]);
end

nImages = size(tSeries,1);
blurSeries = zeros(size(tSeries));

for i =1:nImages
  tmp = reshape(tSeries(i,:),curSize(1),curSize(2));
  blurSeries(i,:) = reshape(cirConv2(tmp,kernel),1,prod(curSize));
end

%End mrBlurTimeSeries

