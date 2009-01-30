function [anatBtnList, expBtnList,tSeries] = mrCreateExpBtns(anatmap)
%
%  MRCREATEEXPBTNS
%
%   btnlist = mrCreateExpBtns(anatmap)
%
%  Author:  Engel
%
%  Date: 5/13/95
%
%  Purpose:  Creates buttons to change functional series in mrLoadRet
%		Top row is anatomical plane, bottom row is Exp. number

% 6/9/95 	gmb	Edited to clear tSeries
% 1/19/96	gmb	Changed input to mrNewExpBtn.  Added sliminlist and slimaxlist options
% 12/9/97	gmb	Converted to matlab 5

numanats = max(anatmap);
numexps = 0;
for i = 1:numanats
	tmp = sum(anatmap==i);
	if (tmp > numexps)
		numexps = tmp;
	end
end

if numanats<10
  width = .08;
else
  width = 0.1;
end
height = .05;
%margin = .01;
left = 0.01;
if numanats > 1
for i = 1:numanats
	bot =  i*.8/numanats;
	str = ['[curSer, tSeries,sliminlist,slimaxlist] = mrNewExpBtn(anatBtnList,expBtnList,1,',num2str(i),', anatmap,sliminlist,slimaxlist);RefreshScreen'];
	anatBtnList(i)= uicontrol('Style','radiobutton','String',num2str(i),'Units','normalized',...
		'Position',[left,bot,width,height], ...
		'Callback', str,'FontSize',12);
end
set(anatBtnList(1),'Value',1);
else
anatBtnList = [];
end

bot = 1-left-height;
for i = 1:numexps
	left =  (i-.8)*.95/numexps;
	%left =  (i-1)*(1-width-margin*2)/(numexps-1)+margin;
	str = ['[curSer, tSeries] = mrNewExpBtn(anatBtnList,expBtnList,0,',num2str(i),',anatmap,sliminlist,slimaxlist);RefreshScreen'];
	expBtnList(i)= uicontrol('Style','radiobutton','String',num2str(i),'Units','normalized',...
		'Position',[left,bot,width,height], ...
		'Callback', str,'FontSize',12);
end
set(expBtnList(1),'Value',1);



