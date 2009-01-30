function y = xcorr2fast(a, b)
% xcorr2fast(a,b)
%	Uses a fft method to quickly calculate the crosscorrelation
%	of a and b.  This method is much faster than Matlab's 
%	xcorr2 function.
%
% Rick Anthony
% 8/24/93


%%[am an] = size(a);
%%[bm bn] = size(b);

%%cm = am+bm-1;
%%cn = an+bn-1;

%%y = real(ifft2(fft2(a,cm,cn).*fft2(flipud(fliplr(b)),cm,cn)));

disp('Please use convolvecirc(a, flipud(fliplr(b))');
disp('xcorr2fast will become obsolete 4/1/95');
 
convolvecirc(a, flipud(fliplr(b)));
