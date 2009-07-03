% mkGaussKernel.m
% ---------------
%
% function kernel = mkGaussKernel(kernelSize, sd)
%
%  AUTHOR: Brian Wandell
%    DATE: December, 1995
% PURPOSE:
%	  Creates a (semi) Gaussian kernel kernelSize(1) x kernelSize(2)
%	  using the numerical form  exp(- ((x - imageCenter)/sd)^2)
%	  such that the sum of the kernel entries sum to 1.
%
% ARGUMENDS:
%         kernelSize: It contains just that, the size of the kernel 
%                     with the complication that it can contain either
%                     2 OR 1 positive integer numbers. When it contains
%                     2 numbers then kernelSize(1) is the number of the 
%                     rows and kernelSize(2) is the number of the columns.
%                     If, on the other hand, length(kernelSize)==1 then 
%                     the kernel is a square matrix of side kernelSize.
%                 sd: It is a vector of length 2 OR 1. When length is 2 
%                     sd(1) is the standard deviation in the x-direction
%                     (rows) and sd(2) is the standard deviation along the
%                     y-direction (columns). If the length of sd is 1 then
%                     the standard deviation in both directions is equal to
%                     sd.
%
% RETURNS:
%         kernel: The (semi) Gaussian kernel.
%                 (Size: kernelSize(1) x kernelSize(2) ).
%
%

function kernel = mkGaussKernel(kernelSize,sd)


if length(kernelSize) == 1

 kernel = zeros(kernelSize,kernelSize);

 x = 1:kernelSize;
 g = exp(- ((x - (kernelSize/2) - 0.5) ./ sd) .^ 2);
 kernel = g'*g;

elseif length(kernelSize) == 2

  if length(sd) ~= 2 
    error('We need 2 sd terms for this kernel')
  end

  kernel = zeros(kernelSize(1),kernelSize(2));

  x = 1:kernelSize(1);
  g1 = exp(- ((x - (kernelSize(1)/2) - 0.5) ./ sd(1)) .^ 2);

  x = 1:kernelSize(2);
  g2 = exp(- ((x - (kernelSize(2)/2) - 0.5) ./ sd(2)) .^ 2);

  kernel = g1'*g2;

end

s = sum(sum(kernel));

if s == 0
  error('The kernel has all zero entries.  No kernel computed.');
else
 kernel = kernel ./ s;
 return
end


%%%%


