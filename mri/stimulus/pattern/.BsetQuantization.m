res = function quantize(in,nLevels)
%
%AUTHOR:  Wandell
%DATE:    05.27.95
%PURPOSE:
%  Quantize the input function to a set of nLevels.
%
%
in = ang;
nLevels = nAng;

mn = mmin(in);
mx = mmax(in);

res = round(scale(in,1,nLevels));
res = scale(res,mn,mx);
