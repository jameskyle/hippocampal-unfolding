function [tSeries,graphWin] = ...
    mrTsPlotRet(anatmap,curSer,tSeries,selpts, ...
    ncycles,junkimages,tFilter,viewPlane,graphWin,loadRetWin);
% 
% tSeries = ...
%    mrTsPlotRet(curAnat,tSeries,selpts,ncycles,junkimages,tFilter,viewPlane,graphWin,loadRetWin);
% 
% Plots an averaged time series for the ROI
%	nCycles:  Number of cycles in the time series
%  Plot an average of the time series data within a region.

% 6/9/95   gmb	 Added load tSeries load error check.
% 9/16/96  gmb   Loads tSeries when needed.
% 11/24/96 gmb   Aborts cleanly if tSeries file is not found.
% 01.15.97 baw,abp    Change to plot percent modulation
% 01.21.97 abp        Force ytlabels to have 4 positions (bug fix)
% 1/23/97  gmb   Plots in a second window
% 07/09/97 lea   Updated to 5.0

% how many positions for the 'yticklabels'
stringPositions = 6;

selpts = mrExtractROIRet(anatmap(curSer),selpts);
if ~any(selpts)  return;
else  selpts = selpts(1,:);
end
		
if isempty(tSeries)
  tSeries=mrLoadTSeries(curSer,viewPlane);
end




if prod(size(tSeries))>0

% 7/09/97 Lea updated to 5.0
  if exist('graphWin')
    if ~isempty(graphWin)
      figure(graphWin);
    else
      graphWin=figure;
    end
    set(gcf,'Name','Time Series');
  end

  mrColorBar(0,'off');
  
  smoothTS = ...
      tsmooth(mean(tSeries(junkimages+1:size(tSeries,1),selpts)')', ...
      tFilter(1),tFilter(2));

  % Plot the time series as a percent modulation 
  ave = mean(smoothTS);
  plot(100*(smoothTS - ave)/ave,'LineWidth',2);
  
  nTicks = size(tSeries,1)-junkimages;
  xtick = [1:ncycles]*(nTicks/ncycles);

  set(gca,'xtick',xtick)

  % We place the mean value of the time series at the zero contrast
  % location on the yticklabels.  We think that the data will
  % always vary around 0.0, so that level should always be there.



%  set(gca,'yticklabel',ytlabelsNew)
% -----------------------------------------------------------------


% 7/09/97 Lea updated to 5.0

  yt = get(gca,'yticklabel');
  yt_num = str2num(yt);
  yt_num(find(yt_num == 0)) = ave;
  yt = num2str(yt_num);

  set(gca,'yticklabel',yt);
  ylabel('Percent modulation') 

  grid on, hold off
  
  if exist('loadRetWin')
    figure(loadRetWin);
  end
end




