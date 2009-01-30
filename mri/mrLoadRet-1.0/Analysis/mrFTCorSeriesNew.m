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

% 12/19/97 abp,bw
%      We changed the variable called "mag" to "scaledAmp" and
%      we added some comments.
%	
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
%
% 12/31/97  djh  Fixed the phase calculation.  gmb had put
%           something really weird in there:
%                ph = -pi/2-(angle(ft(freq+1,:))-freq*pi/datlen);
%           I replaced that with:
%                ph=-(pi/2)-angle(ft(freq+1,:));

%SAE put in check for all zeros in tSeries

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

% This quantity is proportional to the amplitude
% 
scaledAmp = abs(ft);

% This is in fact, the correct amplitude
% 
amp=2*(scaledAmp(freq+1,:))/size(dat,1);

clear dat

% avoid "Warning: Divide by zeros"'s -- What does this mean ?? (BW)
% 
% We use the scaled amp here which is OK for computing the correlation.
%
acor = zeros(size(scaledAmp(freq+1,:)));
sqrtsummagsq=sqrt(sum(scaledAmp.*scaledAmp));
not_zero=find(sqrtsummagsq>0);
if(sum(sum(not_zero)) > 1)    %Need at least 1
  acor(not_zero) = scaledAmp(freq+1,not_zero)./sqrtsummagsq(not_zero);
end
clear scaledAmp

% Calculate phase:
% 1) add pi/2 so that it is in sine phase.
% 2) minus sign because sin(x-phi) is shifted to the right by phi.
% 3) Add 2pi to any negative values so phases increase from 0 to 2pi.
ph=-(pi/2) - angle(ft(freq+1,:));
ph(ph<0)=ph(ph<0)+pi*2;

% Replace NaN's with zero
acor=replaceValue(acor,NaN,0);
amp=replaceValue(amp,NaN,0);
