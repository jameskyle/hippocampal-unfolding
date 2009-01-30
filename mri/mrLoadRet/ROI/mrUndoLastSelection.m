function [selpts,selptsOld]=mrUndoLastSelection(selpts,selptsOld)
%[selpts,selptsOld]=mrUndoLastSelection(selpts,selptsOld)
%
%Switches=selpts with selptsOld

temp = selpts;
selpts = selptsOld;
selptsOld=temp;




