function [upIm, upSize] = upSample(im,imSize)
%  [upIm, upSize] = upSample(im,imSize)
%
%  Take an image vector with shape defined by imSize and up-sample
%  the data in two dimensions by pixel replication.  The upsampling
%  takes place using the Kronecker delta method.  Probably there is
%  some subscripting method that would make it faster.
%
im = reshape(im,imSize(1),imSize(2));
up = [1 0; 0 0];
upIm = kron(im,up);
upSize = size(upIm);
upIm = reshape(upIm,1,prod(upSize));
