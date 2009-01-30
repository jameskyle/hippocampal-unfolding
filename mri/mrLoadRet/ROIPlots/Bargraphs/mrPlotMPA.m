function graphWin = ...
    mrPlotMPA(selpts,co,amp,ph,numofanats,numofexps,graphWin,loadRetWin,curSer)

%mrPlotMPA
%	Plots a bar graph of projected amplitudes averaged over the current ROI
%	Average is taken across all slices and for phases in the phase
%	window.   Error bars are standard errors of the mean.
%
%USAGE
%function graphWin = ...
%    mrPlotMPA(selpts,co,amp,ph,numofanats,numofexps,graphWin,loadRetWin,curSer)
%
%SEE ALSO
%	mrMeanAmp   mybar mrPlotExpAmps mrPlotVectorMean

%12/14/95 gmb  Wrote mrPlotExpAmps
% 1/23/97 gmb  Plots in a second window and labels y axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 4/21/97  gmb  Wrote mrPlotVectorMean from mrPlotExpAmps
% 11/17/97 gmb  Wrote mrPlotMPA from mrPlotVectorMean

if size(selpts,2)>0
  
  if exist('graphWin')
    if ~isempty(graphWin)
      figure(graphWin);
    else
      graphWin=figure;
    end
    set(gcf,'Name','Mean Projected Amplitude Graph');
  end

  mrColorBar(0,'off');
  
  [m,sd,num]=mrMeanProjAmp(selpts,co,amp,ph,numofanats,curSer);
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
  ylabel('Mean Projected Amp');
 
  grid on 
  
  if exist('loadRetWin')
    figure(loadRetWin);
  end
else
  disp('No region of interest selected for any anatomy image.');
end

  
  


