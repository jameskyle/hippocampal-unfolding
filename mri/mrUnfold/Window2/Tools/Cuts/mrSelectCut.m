function [showCut, cutNodes] = mrSelectCut(selectedNodes,layer1Struct,volStruct)
% 
% [showCut, cutNodes] = mrSelectCut(selectedNodes,layer1Struct,volStruct)
% 
% AUTHOR: S. Chial
% DATE:   11.22.97
% PURPOSE:
%   Find the indices between the selected nodes on the cut path
% HISTORY: 
% 11.22.97 SJC	Modified mrVolSelecteLine to select a line to create
%		a cut file for unfolding
% 01.07.98 SJC	grouped related variables into structures
% 06.30.98 SJC	changed cutNodes indexing so that cutNodes are indeces
%		into the original grayNodes
% 07.10.98 SJC	changed name from mrSelectCut.m to mrSelectCut.m
%		because mrVol will now be mrUnfold.m
%
% BUGS:	mrGeodesic returns repeat nodes!
%

%%%%%%%%
% Initialization
%
spacing = 0.5;
crit = 0.05;
cutNodes = [];
numNodes = length(selectedNodes);

%%%%%%%%
% Check for errors in list of selected nodes
%
if (numNodes < 2)
  showCut = -1;
  error('2 or more nodes are needed to create a cut.  Please try again.');
elseif (layer1Struct.dist(selectedNodes(numNodes)) <= volStruct.radius)
  showCut = -1;
  error('Last point selected must be outside the unfold area.  Please try again.');
end


%%%%%%%%
% Find nodes on geodesic between selected nodes and add to cutNodes except
% between the last two selected nodes
%
if (numNodes > 2)
  for i = 1:(numNodes-2)
    cutNodesi = mrGeodesic(layer1Struct.nodes,layer1Struct.edges,volStruct.dimdist,volStruct.radius,spacing,crit,selectedNodes(i),selectedNodes(i+1))
    if isempty(cutNodesi)
      disp('WARNING mrSelectCut: No geodesic line indices returned using selected seeds');
      disp('  Perhaps you should increase radius parameter.');
      showCut = -1;
      cutNodes = [];
      return
    else
      cutNodes = [cutNodes;selectedNodes(i);cutNodesi];
    end
  end
end

%%%%%%%%
% Find nodes on geodesic between last two selected nodes and add all nodes
% within unfold area to cutNodes
%
cutNodesi = mrGeodesic(layer1Struct.nodes,layer1Struct.edges,volStruct.dimdist,volStruct.radius,spacing,crit,selectedNodes(numNodes-1),selectedNodes(numNodes));

if isempty(cutNodesi)
  disp('WARNING mrSelectCut: No geodesic line indeces returned using selected seeds');
  disp('  Last node selected is not a gray matter node.');
  showCut = -1;
  cutNodes = [];
  return
else
  validNodes = find(layer1Struct.dist(cutNodesi) <= volStruct.radius);
  cutNodesi = cutNodesi(validNodes);
  cutNodes = [cutNodes;selectedNodes(numNodes-1);cutNodesi];
end

%%%%%%%%
% Mapping cut node indeces back to indeces into grayNodes
cutNodes = layer1Struct.layer1(cutNodes);

%%%%%%%%

showCut = 1;

return

