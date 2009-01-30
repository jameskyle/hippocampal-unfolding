function [tSeries,graphWin] = ...
    mrFftRoi(anatmap,curSer,tSeries,selpts,ncycles,junkimages,viewPlane,graphWin,loadRetWin)
%tSeries = mrFftRoi(curAnat,tSeries,selpts,ncycles,junkimages,graphWin,loadRetWin)
%	Plots an FFT of the time series for the ROI

% 9/16/96  gmb   Loads tSeries when needed.
% 11/24/96 gmb   Aborts cleanly if tSeries file is not found.
% 1/23/97 gmb   Plots in a second window

selpts = mrExtractROIRet (anatmap(curSer),selpts);
if ~any(selpts)
   return;
else
   selpts = selpts(1,:);
end
		
if isempty(tSeries)
  tSeries=mrLoadTSeries(curSer,viewPlane);
end

% 7/09/97 Lea updated to 5.0		
s=size(tSeries);
if prod(s)>0
  if exist('graphWin')
    if ~isempty(graphWin)
      figure(graphWin);
    else
      graphWin=figure;
    end
    set(gcf,'Name','FFT of Time Series');
  end
  maxCycles = min(20,ceil(s(1)/2));
  mrColorBar(0,'off');
  foo = tSeries(junkimages+1:size(tSeries,1),selpts(1,:));
  foo2=2*abs(fft(mean(foo')')) / s(1);
  plot(1:maxCycles,foo2(2:maxCycles+1),'r',1:maxCycles,foo2(2:maxCycles+1),'ro','LineWidth',2);
  hold on
  plot(ncycles-1:ncycles+1,foo2(ncycles:ncycles+2),'b','LineWidth',2);
  xlabel('Cycles per scan');
  ylabel('Amplitude');
  hold off
  xtick=ncycles:ncycles:(maxCycles+1);
  set(gca,'xtick',xtick);
  grid on 
  if exist('loadRetWin')
    figure(loadRetWin);
  end
end
