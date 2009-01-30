function [buttonid,inpstr] = mrFullAnalIfileMenu(curSer)

qt='''';		 	% String of single quote '
nsteps=8;		 	% Eight easy steps for data analysis

clear inpstr
inpstr(1,:)='enter initial parameters ';
inpstr(2,:)='clip & save anatomies    ';
inpstr(3,:)='reconstruct P files      ';
inpstr(4,:)='unpack P files           ';
inpstr(5,:)='calculate time series    ';
inpstr(6,:)='calculate correlations   ';
inpstr(7,:)='compress image files     ';
inpstr(8,:)='tape-backup image files  ';

%set up buttons
stepsize=25;
bottom=stepsize*(nsteps+2);

% 7/07/ Lea updated to 5.0
%figure(999)
figure
Pos=get(gcf,'Position');
Pos(3)=240;
Pos(4)=bottom+stepsize;
set(gcf,'Position',Pos);
%clg
clf
set(gca,'XColor','k')
set(gca,'YColor','k')

for i=1:nsteps
	buttonid(i)=uicontrol('style','radiobutton','string',inpstr(i,:), ...
	'Position',[20,bottom-i*stepsize,200,20]);
end

StartButton=uicontrol('style','pushbutton','string','OK','Position',[20,bottom-(nsteps+1)*stepsize,200,20],'CallBack','mrFullAnalIfiles(buttonid,inpstr,curSer)');

axis off
disp(['Choose the analysis steps and select ',qt,'OK',qt]);













