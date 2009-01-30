function [graphWin,tSeries,meantSeries] = ...
    plotMeanTSeries(selpts,slices,curSer,tFilter,graphWin,loadRetWin,viewplane)
% 
% 
% graphWin = ...
%  plotMeanTSeries(selpts,[slices or tSeries],...
%                     curSer,tFilter,graphWin,loadRetWin)
%
% 
% Plot the mean tSeries, averaging across all pixels (in all
% slices) in the current ROI.  Smooths the mean tSeries by
% tFilter.

% Started editing for Matlab 5.0.

% 01/23/98  ABP  line 56 contained misspelling of viewplane.
%                Changed incorrect 'viewPlane' to 'viewplane'.
%                Same line also called 	'mrLoadTSeries' with
%                'curSer' rather than correct 'curExp'.
% 01/19/98  bw   Inserted mrLoadTSeries to handle case
%                flattened representation.  Needed to add
%                viewplane parameter for this
% 01/19/98  bw   Adjusted nTick calculation for junkimages
% 12/10/97  gmb  Turned it into a function
% 

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
      %disp([int2str(length(pts)),' pixels']);

    end
  end
end

% mean tSeries
if nSubtSeries>0
  meantSeries = 100*sumSubtSeries/nSubtSeries;
  % smooth it
  if ~exist('tFilter')
    tFilter = [1,1];
  end
  
  smoothTS = tsmooth(meantSeries,tFilter(1),tFilter(2));
  % plot it

  if ~isempty(graphWin)
    figure(graphWin);
  else
    graphWin=figure;
  end
  set(gcf,'Name','Time Series');
  mrColorBar(0,'off');
  plot(smoothTS,'LineWidth',2);

  % BW:  Changed the computation of nTicks to take into account
  % the junkimages.  01.19.98
  nTicks = size(tSeries,1) - junkimages;
  xtick = [1:ncycles]*(nTicks/ncycles);

  set(gca,'xtick',xtick)
  ylabel('Percent modulation') 
  grid on
  if exist('loadRetWin')
    figure(loadRetWin);
  end
else
  disp('no ROI found.');
end





