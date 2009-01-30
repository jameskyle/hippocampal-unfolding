function [curImage, curSize, curCrop] = mrClipRet (curImage, curSize);

%  mrClipRet(curImage, curSize)
%
%	Clips the current image and returns curImage, curSize, and curCrop (in that
% order).  The returned values all correspond to the cropped image. 


% Variable Declarations
nuCrop = [];
nuSize = [];

myShowImage(curImage,curSize);
[nuCrop nuSize] = mrCrop;
curImage = cropImage(curImage,curSize,nuCrop);
curSize = nuSize;
curCrop = nuCrop;
myShowImage(curImage,curSize);		
