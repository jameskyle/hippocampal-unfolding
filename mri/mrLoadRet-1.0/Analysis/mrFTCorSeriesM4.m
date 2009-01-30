function [acor,ph,amp,dc] = mrFTCorSeries(dat, freq, ltrend)
% MRFTCORSERIES
%	[acor,ph,amp,dc] = mrFTCorSeries(dat, freq,[ltrend])
%
%	Compute the correlation in the data w/resepct to the sinusoid of
%	phase that fits the data best.  Do this for each column of the data.
%	Returns correlation, phase and amplitude at the frequency of interest.
%
%	Dat is the data.  freq is the number of cycles per time series.
%	if ltrend(1)=='y' the linear trend is subtracted.

% 7/4/95 gmb  Changed definition of 'phase'.  
%	      Phase is now in sine-phase
%             Increasing phase means increasing temporal delay.
%
% 7/21/97 hab   Added some "clear" statements to clear certain
%               temporary variables from workspace.  This
%               prevented Matlab from running out of memory for
%               large datasets.
%
% 8/6/97  djh  modified to return the dc

datlen = size(dat,1);

dc = mean(dat);
dat = dat - (ones(datlen,1)*dc);

if (exist('ltrend'))
  if (ltrend(1)=='y')
	model = [(1:datlen);ones(1,datlen)]';
	wgts = model\dat;
	fit = model*wgts;
	dat = dat - fit;
	clear model wgts fit
  end
end

ft = fft(dat);
ft = ft(1:(size(ft,1)/2),:);
mag = abs(ft);

amp=2*(mag(freq+1,:))/size(dat,1);

clear dat

%avoid "Warning: Divide by zeros"'s
acor = zeros(size(mag(freq+1,:)));
sqrtsummagsq=sqrt(sum(mag.*mag));
not_zero=find(sqrtsummagsq>0);
acor(not_zero) = mag(freq+1,not_zero)./sqrtsummagsq(not_zero);

clear mag

ph = -pi/2-(angle(ft(freq+1,:))-freq*pi/datlen);
ph(ph<0)=ph(ph<0)+pi*2;

% Replace NaN's with zero
acor=replaceValue(acor,NaN,0);
amp=replaceValue(amp,NaN,0);
