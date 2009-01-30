function graphWin = ...
    mrPlotExpAmps(selpts,amp,ph,pWindow,numofanats,numofexps,graphWin,loadRetWin,kind)
%mrPlotExpAmps
%	Plots a bar graph of amplitudes averaged over the current ROI
%	Average is taken across all slices and for phases in the phase
%	window.   Error bars are standard errors of the mean.
%
%USAGE
%	graphWin = ...
%    mrPlotExpAmps(selpts,amp,ph,pWindow,numofanats,numofexps,graphWin,loadRetWin,name)
%
%SEE ALSO
%	mrMeanAmp   mybar

%12/14/95 gmb  Wrote it.
% 1/23/97 gmb  Plots in a second window and labels y axis

if size(selpts,2)>0
  
  if exist('graphWin')
    if ~isempty(graphWin)
      figure(graphWin);
    else
      graphWin=figure;
    end
    set(gcf,'Name','Bar Graph');
  end
  
  mrColorBar(0,'off');
  [m,sd,num]=mrMeanAmp(selpts,amp,ph,pWindow,numofanats);
  str='';
  for i=numofexps/numofanats:-1:1
    tmp=num2str(i);
    if size(str,2)>length(tmp)
      tmp=[tmp,' '];
    end
    str(i,:)=tmp;
  end
  mybar(m,sd./sqrt(num),str);
  xlabel('Experiment');
  if kind == 1
    ylabel('Correlation');
  elseif kind == 2
    ylabel('Amplitude');
  end

  grid on 
  
  if exist('loadRetWin')
    figure(loadRetWin);
  end
else
  disp('No region of interest selected for any anatomy image.');
end

  
  


