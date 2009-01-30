function result = cirConv2(img, kernel)
% cirConv2(img, kernel)
%	Returns the circular convolution of img and kernel.  The 
%	result will have the same dimensions as img.  This routine
%	employs a fft method to calculate the convolution.  The 
%	origin of the kernel is assumed to be its mid-point or the
%	point immediately less than the mid-point if there are an
%	even number of rows or columns.
%
% Note: kernel cannot be larger in number of rows or columns than img.
%
% Note (Hagit Hel-Or 2/16/95): actually performs correlation and not
%                              convolution
%
% Rick Anthony
% 8/24/93

[im in] = size(img);
[km kn] = size(kernel);

if (km > im | kn > in)
    error('Kernel must not be larger than the image');
end

I = fft2(img, im, in);
K = fft2(kernel, im, in);

cm = round(km/2);
cn = round(kn/2);

result = real(ifft2(I.*K));

result = [result(cm:im,cn:in) result(cm:im,1:cn-1);
          result(1:cm-1,cn:in) result(1:cm-1,1:cn-1)];

