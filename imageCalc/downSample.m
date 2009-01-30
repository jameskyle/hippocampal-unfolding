function [imDown,imDownSize] = downSample(im, imSize)
%
% [imDown,imDownSize]=downSample(im,imSize)
%
%   Return a matrix containing every other entry of the input image.
%
tmp = reshape(im,imSize(1),imSize(2));
imDown = tmp(1:2:imSize(1),1:2:imSize(2));
imDownSize = size(imDown);
imDown = reshape(imDown,1,prod(imDownSize));
