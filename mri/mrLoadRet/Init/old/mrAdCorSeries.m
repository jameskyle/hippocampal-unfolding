function [acor, phaze, sephaze] = mrAdCorSeries(dat, nCycles)
% MRADCORSERIES
% [acor, phaze, sephaze] = mrAdCorSeries(dat, nCycles)
%
%	dat:  The time series data
%	nCycles: The number of cycles per time series
%
%	Compute the correlation in the data w/resepct to the sinusoid of
%	phase that fits the data best.  Do this for each column of the data.
%	
%	Method:  Compute the two fourier weights at the given frequency.
%		Return the arctangent as the phase, the magnitude as 
%		correlation.  First removes DC and linear trends from data.

datlen = size(dat,1);
N = datlen/nCycles;
if ((floor(N)*nCycles) ~= datlen)
	error('The columns in dat have to be a multiple of fun.');
end

% Remove DC (mean)
dc = mean(dat);
dat = dat - (ones(datlen,1)*dc);
 
%Remove linear trend
model = [(1:datlen);ones(1,datlen)]';
wgts = model\dat;
fit = model*wgts;
dat = dat - fit;

sn = sin(2*pi*[0:N-1]/N);
cs = cos(2*pi*[0:N-1]/N);
cosnorm=cs*cs';
sinnorm=sn*sn';

for reps = 1:nCycles
tmp = (dat([(N*(reps-1)+1):(N*reps)],:));
c(reps,:) = cs*tmp;
s(reps,:) = sn*tmp;
	for j = 1:size(dat,2)
		tmp2 = (dat([(N*(reps-1)+1):(N*reps)],j));
		datanorm = tmp2'*tmp2;
		c(reps,j)=c(reps,j)/((datanorm*cosnorm)^.5);
		s(reps,j)=s(reps,j)/((datanorm*sinnorm)^.5);
	end
end

msg = 'done w/step 1'

if nCycles > 1
	cbar = mean(c);
	sbar = mean(s);
else
	cbar = c;
	sbar = s;
end

phaze = atan2(cbar,sbar);
dum = ones(nCycles,1);
rotc = (s.*(dum*cos(-phaze)))-(c.*(dum*sin(-phaze)));
rots = (s.*(dum*sin(-phaze)))+(c.*(dum*cos(-phaze)));
sephaze = std(atan2(rotc,rots))/sqrt(nCycles);

msg = 'starting step 2'

sinin = [0:(datlen-1)]*nCycles*2*pi/datlen;
newcs = cos(sinin);
newsn = sin(sinin);
newcosnorm=newcs*newcs';
newsinnorm=newsn*newsn';
for i = (1:size(dat,2))
tmp = dat(:,i);
newdatnorm = tmp'*tmp;
newc = (newcs*tmp)/sqrt(newcosnorm*newdatnorm);
news = (newsn*tmp)/sqrt(newsinnorm*newdatnorm);
acor(i) = (sqrt((news.^2)+(newc.^2)));
end
