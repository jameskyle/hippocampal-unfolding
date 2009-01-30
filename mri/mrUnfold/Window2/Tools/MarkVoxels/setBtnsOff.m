function areaBtnList = setBtnsOff(areaBtnList,activeBtn)
% function areaBtnList = setBtnsOff(areaBtnList,activeBtn)
% 

btns = [1:length(areaBtnList)];
btns(activeBtn) = [];

for ii = btns

  set(areaBtnList(ii),'Value',0);

end