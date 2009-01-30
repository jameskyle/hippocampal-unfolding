function [newAnat,newCurSize,newCurCrop] =...
   mrDownSampleAnat(anat,curSize,curCrop,subFactor)

%[newAnat,newCurSize,newCurCrop] =...
%   mrDownSampleAnat(anat,curSize,curCrop,subFactor)
%
%Blur and downsample anatomy images so that they're compatible
%with 128x128 functional images.

%3/21/97   gmb   Wrote it.

numofanats = size(anat,1);

%Gaussian kernel for blurring
kernel = mkGaussian([subFactor*2+1,subFactor*2+1],subFactor/exp(1));;

%Sub sampling grid
[x,y] = meshgrid([1:curSize(2)],[1:curSize(1)]);
sampGrid = ((-1).^x + (-1).^y) == -2;

%New image sizes and crop rectangle
newCurSize = ceil(curSize/subFactor);
newCurCrop = [round(curCrop(1,:)/subFactor);(round(curCrop(1,:)/subFactor) +fliplr(newCurSize)-1)];
newAnat = zeros(numofanats,prod(newCurSize));

%Loop through, filter and subsample each anatomy
for curAnat = 1:numofanats
  img = reshape(anat(curAnat,:),curSize(1),curSize(2));
  img = conv2(img,kernel,'same');
  img=img(sampGrid)';
  
  newAnat(curAnat,:)=img;
end





