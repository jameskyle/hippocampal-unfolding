function layer1Struct = mrSelectLayer1(grayStruct,grayMatter,anatomy);
%function layer1Struct = mrSelectLayer1(grayStruct,grayMatter,anatomy);
%
% AUTHOR: S. Chial
% DATE:   March 21, 1997
% PURPOSE:
%  Return the first layer nodes and edges (either by selecting them or by loading
%  the saved first layer nodes and edges).  If the first layer nodes need to be
%  selected, they will be saved so that they won't need to be selected again the
%  next time this gray file is viewed using mrVol.
% ARGUMENTS:	grayStruct	contains the fields 'nodes','edges','selectedNode'
%				for all the gray matter nodes
%		grayMatter	and 'dist' contains the fields 'dir' and 'file', the directory
%				and filename of the gray matter file
% RETURNS:	layer1Struct	contains the fields 'nodes', 'edges', 'layer1map'
%				and 'dist' for the first layer gray matter nodes
% MODIFICATIONS:
% 05.12.98 SJC	changed 'grayF' into a structure 'grayMatter' that contains the fields
%		'dir' and 'file'
% 05.26.98 SJC	removed the field 'selectedNode' from layer1Struct and added the field
%		'layer1map'
% 07.10.98 SJC	changed name from mrVolSelectLayer1.m to mrSelectLayer1.m because
%		mrVol will now be mrUnfold
%

layer1file = [anatomy.dir '/' grayMatter.hemisphere '/unfold/' grayMatter.file '_layer1'];

% Read in the nodes and edges in layer 1
%
if (exist(layer1file) == 2)
  cmd = ['load ' layer1file ' -mat'];
  eval(cmd);
  layer1Struct.nodes = nodes1;
  layer1Struct.edges = edges1;
  layer1Struct.layer1 = layer1;
  layer1Struct.layer1map = layer1map;
else
  fprintf('Finding layer 1 gray matter nodes...\n');
  layer1 = find(grayStruct.nodes(6,:) == 1);
  [layer1Struct.nodes, layer1Struct.edges] = keepNodes(grayStruct.nodes,grayStruct.edges,layer1);
  layer1map = - ones(1,size(grayStruct.nodes,2));
  layer1map(layer1) = [1:length(layer1)];

  nodes1 = layer1Struct.nodes;
  edges1 = layer1Struct.edges;
  layer1Struct.layer1 = layer1;
  layer1Struct.layer1map = layer1map;

  fprintf('Saving layer1 gray matter nodes in %s\n', layer1file);
  cmd = ['save ' layer1file ' nodes1 edges1 layer1 layer1map'];
  eval(cmd);
end

layer1Struct.dist = [];

return;