% mrShowCut.m
% script


displayStruct.flags = [-1 -1 1 -1 -1];

if isempty(cutNodes)
  displayStruct.flags = [-1 -1 -1 -1 -1];
  disp('No cuts have been made.');
else
  if isempty(layer1Struct.nodes)
    layer1Struct = mrSelectLayer1(grayStruct,grayMatter);
  end
  [selectedNode,displayStruct.flags(3),imgStruct] = mrOverlayDist(volStruct,displayStruct,layer1Struct,selectedNode,cutNodes,mVoxelsStruct,h_fig2);
end
