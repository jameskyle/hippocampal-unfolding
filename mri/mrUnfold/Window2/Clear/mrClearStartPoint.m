% mrClearStartPoint.m
% script
% 

selectedNode.index = -1;
selectedNode.S = -1;
selectedNode.A = -1;
selectedNode.C = -1;

set(Node_edit,'String',num2str(selectedNode.index));
set(S_edit,'String',num2str(selectedNode.S));
set(A_edit,'String',num2str(selectedNode.A));
set(C_edit,'String',num2str(selectedNode.C));

grayStruct.dist = [];
layer1Struct.dist = [];

displayStruct.flags(1) = -1;

mrChangeImageScript;

return;

