function [co,ph,amp,graphWin]= mrPhaseVsCorr(curSer,curAnat,co,ph,amp,selpts,pWindow,polarFlag,viewPlane,graphWin,loadRetWin)
% mrPhaseVsCorr
% [co,ph,amp]= mrPhaseVsCorr(curSer,curAnat,co,ph,amp,selpts,pWindow,polarFlag,viewPlane,graphWin,loadRetWin)
% 	plots a scatterplot of phase versus correlation
%
%	Yellow: in phase window
%	Red:    out of phase window
%
%			|  1  		Polar plot
%	polarFlag  ==   |
%			|  otherwise 	Cartesian plot

%	6/9/95   gmb   Wrote it
%	9/16/96  gmb   Loads in correlation data if it's not available.
%       11/23/97 gmb   Plots in a second window

if (isempty(co))
  [co, ph, amp]=mrLoadCorAnal(viewPlane);
end

selpts = mrExtractROIRet(curAnat,selpts);
if ~any(selpts) 
   return;
end

if exist('graphWin')
  if ~isempty(graphWin)
    figure(graphWin);
  else
    graphWin=figure;
  end
  if polarFlag == 0
    set(gcf,'Name','Phase Vs. Corr: Cartesian');
  else
    set(gcf,'Name','Phase Vs. Corr: Polar');
  end
end

mrColorBar(0,'off');

scfac=180/pi;
tmp=mrGetInpWindow(ph(curSer,selpts(1,:)),pWindow);
if (polarFlag==1)
	polar(  ph(curSer,selpts(1,tmp)),co(curSer,selpts(1,tmp)),'b+');
	hold on
	polar(	ph(curSer,selpts(1,~tmp)),co(curSer,selpts(1,~tmp)),'r+');
	hold off
%	set(gca,'YLim',max(co(curSer,selpts(1,:)))*[-1,1]);
        ChangeColors('w',[0.7,0.7,0.7]);
else
	if sum(ph(curSer,selpts(1,:)) <0)>0
		ph(curSer,selpts(1,:)<0)=ph(curSer,selpts(1,:))+pi*2;
	end
	plot(	scfac*ph(curSer,selpts(1,~tmp)),co(curSer,selpts(1,~tmp)),'r+');
	hold on
	plot(  scfac*ph(curSer,selpts(1,tmp)),co(curSer,selpts(1,tmp)),'b+');
	hold off
	set(gca,'XTick',[0:45:360]);
	set(gca,'XLim',[0,360]);
	grid
	xlabel('Phase');
	ylabel('Correlation');
end

if exist('loadRetWin')
  figure(loadRetWin);
end
