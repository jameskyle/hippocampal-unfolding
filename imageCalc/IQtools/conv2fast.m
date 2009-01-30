function y = conv2fast(a, b)
% conv2fast(a,b)
%	Uses a fft method to quickly calculate a * b.  This is much
%	faster than Matlab's conv2 function.
%
% Rick Anthony
% 8/24/93;

[am an] = size(a);
[bm bn] = size(b);

cm = am+bm-1;
cn = an+bn-1;

y = real(ifft2(fft2(a,cm,cn).*fft2(b,cm,cn)));
