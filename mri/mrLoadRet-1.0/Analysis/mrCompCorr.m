function [co,ph,amp] = mrCompCorr(tSeries,nCycles)

% function [co,ph,amp] = mrCompCorr(tSeries,nCycles)

tSerieslen=size(tSeries,1);
pixels=size(tSeries,2);

z=fft(tSeries);

ph=angle(z(nCycles+1,:));
mag =( z .* conj(z))';
amp=sqrt(mag(nCycles+1,:))/size(tSeries,1);

co=sqrt(2*mag(nCycles+1,:)')/size(tSeries,1);










