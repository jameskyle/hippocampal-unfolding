function [curSer, tSeries,sliminlist,slimaxlist] = mrNewExpBtn(anatBtnList,expBtnList,anatorexp, num, anatmap,sliminlist,slimaxlist)
%
%  MrNewExpBtn
%
%function [curSer, tSeries,sliminlist,slimaxlist] =  ...
%    mrNewExpBtn(anatBtnList,expBtnList,anatorexp, num, ...
%    anatmap,sliminlist,slimaxlist)
%
%  Author:  Engel
%
%  Date: 5/13/95
%		
%  Purpose: Loads in new series, updates display via mrSlicoControlRet and sets button values.

% 6/9/95  gmb 	Takes in tSeries and returns it empty.
% 1/19/96 gmb 	Changes slimin and slimax values 
%               to values in sliminlist and slimaxlist
%	      	when anatomy slice is changed.
% 06/19/97 ll,abp  updated to 5.0


global slimin slimax;

curanat=1;
%if nargin<=13
%	curanat = 1;
%end
startanat=curanat;

if ~isempty(anatBtnList)	
  for i = 1:length(anatBtnList)
    if(get(anatBtnList(i),'Value') == 1)
      curanat = i;
      set(anatBtnList(i),'Value',0);
    end
  end
end

for i = 1:length(expBtnList)
  if(get(expBtnList(i),'Value') == 1)
    curexp = i;
    set(expBtnList(i),'Value',0);
  end
end

if (anatorexp)
  curanat = num;
else
  curexp = num;
end

curSer = find(cumsum(anatmap == curanat) == curexp);
if(length(curSer) > 1)
curSer = curSer(1);
end

% 06/19/97 ll, abp updated to 5.0

if ~isempty(anatBtnList)
  set(anatBtnList(curanat),'Value',1);
end
set(expBtnList(curexp),'Value',1);

if (nargin>13 & curanat ~=startanat & length(sliminlist)>0)
  %save current slide values for the old anatomy slice
  sliminlist(startanat)=get(slimin,'value');
  slimaxlist(startanat)=get(slimax,'value');
  %set slide values for the new anatomy slice
  set(slimin,'value',sliminlist(curanat));
  set(slimax,'value',slimaxlist(curanat));
end

tSeries=[];

%RefreshScreen should be called after this function is executed.





