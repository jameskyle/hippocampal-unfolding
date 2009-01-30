function y = mrVolShowFlat(flatStruct,mVoxelsStruct,grayStruct,cutNodes,h_fig3)
% function y = mrVolShowFlat(flatStruct,mVoxelsStruct,grayStruct,cutNodes,h_fig3)
%
% Purpose: Displays flattened brain with marked areas of interest, cuts, and
%          the start point of the unfold
%
% 02.19.98 SJC


% Display flattened brain in red
%
figure(h_fig3);
plot(flatStruct.gLocs2d(:,1),flatStruct.gLocs2d(:,2),'r.');
axis ij

% Display marked areas
%
[dummy1 unfV1 dummy2] = intersect(flatStruct.unfList,mVoxelsStruct.Area1);

[dummy1 unfV2 dummy2] = intersect(flatStruct.unfList,mVoxelsStruct.Area2);

[dummy1 unfV3 dummy2] = intersect(flatStruct.unfList,mVoxelsStruct.Area3);

[dummy1 unfV4 dummy2] = intersect(flatStruct.unfList,mVoxelsStruct.Area4);

[dummy1 unfMST dummy2] = intersect(flatStruct.unfList,mVoxelsStruct.Area5);

[dummy1 unfOther dummy2] = intersect(flatStruct.unfList,mVoxelsStruct.Area6);

% Display Start Point as a blue circle
%
curNode = find(flatStruct.unfList == grayStruct.selectedNode);

% Display cut in black
%
[dummy1 unfCut dummy2] = intersect(flatStruct.unfList,cutNodes);

hold on

plot(flatStruct.gLocs2d(unfV1,1),flatStruct.gLocs2d(unfV1,2),'g.',flatStruct.gLocs2d(unfV2,1),flatStruct.gLocs2d(unfV2,2),'b.');
plot(flatStruct.gLocs2d(unfV3,1),flatStruct.gLocs2d(unfV3,2),'y.',flatStruct.gLocs2d(unfV4,1),flatStruct.gLocs2d(unfV4,2),'m.');
plot(flatStruct.gLocs2d(unfMST,1),flatStruct.gLocs2d(unfMST,2),'c.',flatStruct.gLocs2d(unfOther,1),flatStruct.gLocs2d(unfOther,2),'k.');
plot(flatStruct.gLocs2d(unfCut,1),flatStruct.gLocs2d(unfCut,2),'b*',flatStruct.gLocs2d(curNode,1),flatStruct.gLocs2d(curNode,2),'k*');

hold off
