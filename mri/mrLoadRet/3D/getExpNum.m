function expNum = getExpNum(expBtnList);
% function expNum = getExpNum(expBtnList);
%
% AUTHOR:	SJC -- code comes directly from mrNewExpBtn.m
% DATE:		04.16.98
% PURPOSE:	find out which experiment is currently being viewed
% ARGUMENTS:	expBtnList:	List of experiment selection radio button handles
% RETURNS:	expNum:		Number of experiment currently being viewed, zero
%				is default.
% MODIFICATIONS:
% 05.15.98	SJC	Changed function name from 'getScanNum' to 'getExpNum'

expNum = 0;

if ~isempty(expBtnList)        
  for i = 1:length(expBtnList)
    if(get(expBtnList(i),'Value') == 1)
      expNum = i;
    end
  end
end

return;