function result = filt2(img, kernel)
% filt2(img, kernel)
%	Returns the img filtered by the given kernel.  Filtering is
%	accomplished using circular convolution.
%
% Functions called
%	cirConv2()
%
% Rick Anthony
% 8/24/93

result = cirConv2(img, kernel);
