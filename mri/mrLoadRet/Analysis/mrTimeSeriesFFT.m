function [pSpectrum, plotHdl, mts] = mrTimeSeriesFFT(tSeries,selpts,xtick)
%
%    [pSectrum plotHdl] = mrTimeSeriesFFT(tSeries,selpts,xtick)
%
%		tSeries:  time series of the whole data set
%		mts = mean time series of selected region
%		selpts = selected points
%		xtick = frequency values to plot
%  Purpose:
%    Compute the power spectrum of the time series at the
%    currently selected points.  The power spectrum is normalized
%    to have a unit maximum over the plotting range.
%
%AUTHOR:  Engel, Wandell
%DATE:    08.17.94

mts = mean(tSeries(:,selpts(1,:))');

pSpectrum = abs(fft(mts));

pSpectrum = pSpectrum / max(pSpectrum(xtick+1));

plotHdl = plot(xtick,pSpectrum(xtick+1),'-');

grid on
set(gca,'xlim',[min(xtick) max(xtick)],'ylim',[0 1.1])
set(gca,'xtick',xtick,'ytick',[0:.2:1]);

