function [graphWin,tSeries] = ...
    plotFftTSeries(selpts,slices,curSer,graphWin,loadRetWin,viewplane)

% [graphWin,tSeries] = ...
%    plotFftTSeries(selpts,slices,curSer,graphWin,loadRetWin,viewplane)
%
% AUTHOR: Press
% DATE:   4/20/98
% INPUTS:  
% PURPOSE: Compute and plot FFT of ROI time series.  Returns the
%   series for the single-slice case so that it need not be recomputed.

load ExpParams
if ~exist('viewplane')
  viewplane = 'inplane';
end

if size(slices,1)>1 			%a tSeries, not slices was sent in
  tSeries = slices;
  [scanNum,slices] = series2scanSlice(curSer,numofexps,numofanats);
  loadIt = 0;
elseif(isempty(slices))  %no tSeries or slices were sent in
  tSeries = [];
  [scanNum,slices] = series2scanSlice(curSer,numofexps,numofanats);
  loadIt = 1;
else  %slices were sent in
  tSeries = [];
  loadIt = 1;
end

nscans = numofexps/numofanats;
scanNum = series2scanSlice(curSer,numofexps,numofanats);

% Compute mean time series

sumSubtSeries=zeros(imagesperexp-junkimages,1);
nSubtSeries = 0;
for curAnat=slices

  %these are the indices to the pixels in the 
  %ROI that fall in the current inplane:

  if (~isempty(selpts))
    pts = selpts(1,find(selpts(2,:)==curAnat));
    if (~isempty(pts))
      curExp = (curAnat-1)*nscans+scanNum;
      if loadIt
	tSeries=mrLoadTSeries(curExp,viewplane);
      end
      subtSeries = tSeries((junkimages+1):imagesperexp,pts);

      % Get the DC
      dc = mean(subtSeries);

      %divide by the mean
      subtSeries = subtSeries ./(ones((imagesperexp-junkimages),1)*dc);

      %subtract the mean (which is now 1)
      subtSeries = subtSeries - ones(size(subtSeries));

      %subtract the linear trend
      model = ...
	  [(1:(imagesperexp-junkimages));ones(1,(imagesperexp-junkimages))]';
      wgts = model\subtSeries;
      fit = model*wgts;
      subtSeries = subtSeries - fit;

      %add subtSeries' across slices
      sumSubtSeries=sumSubtSeries+sum(subtSeries')';
      nSubtSeries=nSubtSeries+length(pts);

    end
  end
end

% Compute and plot FFT of mean time series.  Lops off
% DC component, which is the first element in the FFT.

if nSubtSeries>0
  
  meantSeries = 100*sumSubtSeries/nSubtSeries;
  
  s = size(meantSeries);

  % There are s(1)/2 unique elements in the FFT (the second half
  % mirrors the first).  Because of the way Matlab does the FFT,
  % you normalize the fft by s(1)/2 to get unit power for a sin wave.
  
  fftSeries = abs(fft(meantSeries)) / (s(1)/2);
  maxCycles = min(20, ceil(s(1)/2));

  if ~isempty(graphWin)
    figure(graphWin);
  else
    graphWin=figure;
  end

  mrColorBar(0,'off');

  plot(1:maxCycles,fftSeries(2:maxCycles+1),'ro-','LineWidth',2);
  hold on
  plot(ncycles-1:ncycles+1,fftSeries(ncycles:ncycles+2),'b','LineWidth',2);
  xlabel('Cycles per scan');
  ylabel('Amplitude');
  hold off
  xtick = ncycles:ncycles:(maxCycles+1);
  set(gca,'xtick',xtick);
  grid on 
  if exist('loadRetWin')
    figure(loadRetWin);
  end

else
  disp('no ROI found.');
end
