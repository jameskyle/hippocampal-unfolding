function [buttonid,inpstr] = mrFullAnalysisMenu(curSer)
%[buttonid,inpstr] = mrFullAnalysisMenu(curSer)
%
%Opens figure 2 and defines labeled buttons for
%analysis steps.  See 'mrFullAnalysis.m' for details.

%6/4/96 gmb	Wrote it
%9/2/96 gmb     Added calculate flat anatomy, time series, and correlations.
%09.30.97 abp   Added 'save first Pfile image'
%04.14.98 sjc	Added 'create 3D correlations' and 'create OFF files' buttons
%05.14.98 sjc	Eliminated 'create OFF files'.  OFF files will be created elsewhere.

qt='''';		 	% String of single quote '

clear inpstr
inpstr(1,:)='clip & save anatomies      ';
inpstr(2,:)='calculate time series      ';
inpstr(3,:)='calculate correlations     ';
inpstr(4,:)='compress P files           ';
inpstr(5,:)='create flat anatomy        ';
inpstr(6,:)='calculate flat time series ';
inpstr(7,:)='calculate flat correlations';
inpstr(8,:)='run post-analysis script   ';
inpstr(9,:)='save first Pfile image     ';
inpstr(10,:)='calculate 3D correlations  ';

nsteps=size(inpstr,1);		 % Only eleven easy steps for data analysis


%set up buttons
stepsize=25;
buttonHeight = 25;
bottom=stepsize*(nsteps+2);

figure('MenuBar','none','Color',[0,0,0.5]);
axes('Position',[0,0,1,1],'Visible','off')

Pos=get(gcf,'Position');
Pos(3)=240;
Pos(4)=bottom+stepsize;
set(gcf,'Position',Pos);
%clf
set(gca,'XColor','k')
set(gca,'YColor','k')

for i=1:nsteps
	buttonid(i)=uicontrol('style','radiobutton','string',inpstr(i,:), ...
	'Position',[20,bottom-i*stepsize,200,buttonHeight],'FontSize',12,'HorizontalAlignment','left');
end

StartButton=uicontrol('style','pushbutton','string','OK','Position',[20,bottom-(nsteps+1)*stepsize,200,buttonHeight],'CallBack','mrFullAnalysis(buttonid,inpstr,curSer)');

disp(['Choose the analysis steps and select ',qt,'OK',qt]);









