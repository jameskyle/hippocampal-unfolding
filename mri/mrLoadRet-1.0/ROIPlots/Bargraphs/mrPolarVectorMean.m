function graphWin = ...
    mrPolarVectorMean(selpts,co,amp,ph,numofanats,numofexps,graphWin,loadRetWin,curSer)

%mrPolarVectorMean
%	Polar plot of amplitudes and phases averaged over the current ROI
%	Average is taken across all slices and for phases in the phase
%	window.   Error bars are standard errors of the mean.
%
%USAGE
%function graphWin = ...
%    mrPolarVectorMean(selpts,co,amp,ph,numofanats,numofexps,graphWin,loadRetWin,curSer)
%
%SEE ALSO
%	mrMeanAmp   mybar mrPlotExpAmps mrPlotVectorMean

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 9/18/97 gmb  Wrote mrPolarVectorMean from mrPlotVectorMean

bkColor = [.5,0.5,0.5];
lineColor = 1*[1,1,1];
nScans = numofexps/numofanats;

if size(selpts,2)>0
  
  if exist('graphWin')
    if ~isempty(graphWin)
      figure(graphWin);
    else
      graphWin=figure;
    end
    set(gcf,'Name','Vector Mean Polar Plot');
  end
  mrColorBar(0,'off');
  clf
  set(gcf,'Color',bkColor);
  [m,sd,num,z]=mrVectorMean(selpts,co,amp,ph,numofanats,curSer);
  str='';
  refexpnum = series2scanSlice(curSer,numofexps,numofanats);
  %set up polar plot
  maxAmp = ceil(max(abs(z)));
  dx = maxAmp/40;

  %radial lines
  for i=linspace(angle(z(refexpnum)),angle(z(refexpnum))+pi,5);
    line([-maxAmp*cos(i),maxAmp*cos(i)],[-maxAmp*sin(i),maxAmp*sin(i)],...
	'Color',lineColor);
    hold on
  end

  %concentric circles.
  arg = linspace(0,pi*2,64);
  for i=1:maxAmp
    x = i*cos(arg);
    y = i*sin(arg);
    plot(x,y,'Color',lineColor);
    %for arg = linspace(0,pi*2,64)
    %  plot(i*cos(arg),i*sin(arg),'.','Color',lineColor);
    %  hold on
    %end
    text(i*cos(angle(z(refexpnum))-pi/4)+dx,i*sin(angle(z(refexpnum))-pi/4)-dx*2,...
	int2str(i),'Color',lineColor);
  end
  
  axis off
  axis equal
  
  for i=1:nScans
    plot([0,real(z(i))],[0,imag(z(i))],'LineWidth',2,'Color','y');
    hold on
    %plot(real(z(i)),imag(z(i)),'g.','MarkerSize',45);
    plot(real(z(i)),imag(z(i)),'g.','MarkerSize',45);
    text(real(z(i)*1)-dx,imag(z(i)*1),int2str(i),'Color','k','FontWeight','bold');
  end
  hold off
  if exist('loadRetWin')
    figure(loadRetWin);
  end
else
  disp('No region of interest selected for any anatomy image.');
end

  
  


