% script
%
% restrictROI
%
% If 'refexpnum' exists, then it uses the reference scan to pick
% a subROI such that reference scan correlations exceed cothresh
% and reference scan phases are within phase window.  If no
% refexpnum exists, uses the the current scan.

% read cothresh from the slide bar
cothresh=get(slico,'Value');

if (size(co,2)<prod(curSize))
  disp('Warning: you need to load the correlation matrices');
end
if ~exist('refexpnum')
  refnum=1;
  for i=1:length(expBtnList)
    if (get(expBtnList(i),'Value')==1)
      refnum=i;
    end
  end
else
  refnum=refexpnum;
end

selptsOld=selpts;
selpts = subSelpts(selpts,co,amp,ph,numofanats,anatmap,refnum,cothresh,pWindow);
