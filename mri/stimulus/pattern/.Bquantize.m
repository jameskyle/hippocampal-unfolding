res = function quantize(in,nLevels)
%
%AUTHOR:  Wandell
%DATE:    05.27.95
%PURPOSE:
%  Quantize the input function to a set of nLevels.
%
%
%
mn = mmin(in);
mx = mmax(in);

res = scale(round(scale(in,1,nLevels)),mn,mx);
