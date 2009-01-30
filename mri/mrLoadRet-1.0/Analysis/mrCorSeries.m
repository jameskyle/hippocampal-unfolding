function [cors, fases] = mrCorSeries(dat, fun)
% MRCORSERIES
% [cors, fases] = mrCorSeries(dat, fun)
%
%	Cross correlate a function with data sets.  The function is a vector
%	that is correlated with each column of the data.  Cors is a column
%	that contains the best corellation of the fun with each column of 
%	the data.  Fases is a column that contains the phase (from 1 to 
%	length fun) at which this best correlation ocurred.
%	
%	The columns in dat have to be a multiple of fun.


datlen = size(dat,1);
funlen = length(fun);
reps = datlen/funlen;
if ((floor(reps)*funlen) ~= datlen)
	error('The columns in dat have to be a multiple of fun.');
end

xfun = fun;
for i = 2:reps
	xfun = [fun;xfun];
end

matfun = xfun;
for i = 1:funlen-1
	matfun = [matfun,[xfun(i+1:datlen);xfun(1:i)]];
end

dum = ones(funlen,1);
dum2 = ones(datlen,1);

aves = mean(dat);
nrm = dat-(dum2*aves);
nrm = nrm ./ (dum2*std(nrm));
aves = mean(matfun);
nfun = matfun - (dum2*aves);
nfun = nfun ./ (dum2*std(nfun));
co = nrm'*nfun/(datlen-1);
[srt,ord] = sort(co');
cors = srt(funlen,:);
fases = ord(funlen,:);




