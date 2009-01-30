function res = interpRGB(origRange, vals, newRange)

dataRange = min(origRange):max(origRange);	% 1 nm steps
intres = interp1(origRange,vals,dataRange);	% Interpolate out
res = zeros(length(newRange),3);		% Zero padding
res((dataRange(1) - newRange(1)+1):length(newRange), 1:3) = intres;

