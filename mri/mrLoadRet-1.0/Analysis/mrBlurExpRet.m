function [blurco,blurph,kern] = mrBlurExpRet(co,ph,numofexps,curSize)
%
% [blurco blurph kern] = mrBlurExpRet(co,ph,numofexps,curSize)
%
%	Blurs the correlation and phase images.
%

% map the phases onto -pi to pi
ph(ph>pi) = ph(ph>pi)-2*pi;

sup = input('Please enter a 2d vector of blurring kernel support >');
sd = input('Please enter a 2d vector of blurring kernel std dev >');
for i = 1:numofexps
	[blurph(i,:) kern] = mrBlurPhaseRet(ph(i,:),sup,sd,curSize);
	tmpco = replaceNaN(co(i,:),0);
	tmpco = cirConv2(reshape(tmpco,curSize(1)...
					,curSize(2)),kern);
	blurco(i,:) = reshape(tmpco,1,prod(curSize));
end

% map the phases back onto 0 to 2*pi
blurph(blurph<0) = blurph(blurph<0)+2*pi;
