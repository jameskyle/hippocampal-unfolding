% mrShowStartPoint
% script
%
% AUTHOR:	SJC
% DATE:		06.25.98
% PURPOSE:	Callback for showing the start point.  Sets the slices being
%		viewed to be the coordinates of the start point.
%

if (selectedNode.index ~= -1)
  displayStruct.iNumber(1) = selectedNode.S;
  displayStruct.iNumber(2) = selectedNode.A;
  displayStruct.iNumber(3) = selectedNode.C;
  set(iNumber_edit(1),'String',selectedNode.S);
  set(iNumber_edit(2),'String',selectedNode.A);
  set(iNumber_edit(3),'String',selectedNode.C);
  mrChangeImageScript;
end
