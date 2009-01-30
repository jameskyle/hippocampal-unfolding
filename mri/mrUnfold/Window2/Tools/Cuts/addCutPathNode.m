function [nextNode, isDone] = addCutPathNode(c,r,button,displayStruct,layer1Struct,volStruct,h_fig2);
%
%

if isempty(layer1Struct.dist)
  error('Start Point for region to unfold has not been set.')
end

switch displayStruct.activeSliceOri
  case 1,				% SAGITTAL grayNode indices
	grayNodeIndex = 3;
	% Create a list of indexes into layer1Struct.nodes which have layer 1 graymatter in this slice
	l = find((layer1Struct.nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri)) & (layer1Struct.nodes(6,:) == 1));
	x = layer1Struct.nodes(1,l); y  = layer1Struct.nodes(2,l);
  case 2,				% AXIAL
	grayNodeIndex = 2;
	l = find((layer1Struct.nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri)) & (layer1Struct.nodes(6,:) == 1));
	x = layer1Struct.nodes(1,l); y = layer1Struct.nodes(3,l); 
  case 3,				% CORONAL 
	grayNodeIndex = 1;
	l = find((layer1Struct.nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri)) & (layer1Struct.nodes(6,:) == 1));
	x = layer1Struct.nodes(2,l); y = layer1Struct.nodes(3,l); 
  otherwise,
	disp('ERROR mrVolSelectLine:  Invalid slice orientations');
	return;
end


if (displayStruct.activeSliceOri ~= 1)
  temp = c;
  c = r;
  r = temp;
end

% Figure out the closest x,y to the c,r 
% 
[v idx] = min(abs(x - c) + abs(y - r));

% 'idx' is where they are on the plane
% 'l(idx) are indices into their data in 'grayNodes'
nextNode = l(idx);

% Checking to see if selected node is inside the unfold area or if right button was pressed
%
if ((layer1Struct.dist(nextNode) > volStruct.radius) | (button == 3))
  isDone = 1;
else
  isDone = 0;
  
  if ((layer1Struct.dist(nextNode) > volStruct.radius) & (button == 1))
    nextNode = [];
    disp('ERROR:  Only last node should be in gray matter outside of unfold area.');
    disp('        Node not selected.');
  end
end

