function [im, nuSize] = mrExtractSubIm(curImage,curSize,cmap)
% [im, nuSize] = mrExtractSubIm(curImage,curSize,[cmap])

if ~exist('cmap')
  cmap = colormap;
end

global slimin slimax

% 7/10/97 Lea updated to 5.0
myShowImage(curImage,curSize);
[nuCrop nuSize] = mrCrop;
[im nuSize] = imCrop(curImage,nuCrop,curSize);
curSize = nuSize;
curCrop = nuCrop;
figure;
colormap(cmap);
myShowImage(im,nuSize,get(slimin,'value')*max(curImage),get(slimax,'value')*max(curImage));
