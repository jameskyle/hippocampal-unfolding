function layer1Struct = mrSelectLayer1(grayStruct,grayMatter,anatomy);
% 
% layer1Struct = mrSelectLayer1(grayStruct,grayMatter,anatomy);
%
% AUTHOR: S. Chial
% DATE:   March 21, 1997
%
% PURPOSE:	Return the first layer nodes and edges.
%  
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
% 08.06.98 SJC	eliminated saving of layer 1 nodes because keepNodes works pretty
%		quickly.  mrSelectLayer finds the layer 1 nodes every time it is called.
%

h = msgbox('Finding layer 1 gray matter nodes...');
pause(1)

layer1 = find(grayStruct.nodes(6,:) == 1);
[layer1Struct.nodes, layer1Struct.edges] = ...
    keepNodes(grayStruct.nodes,grayStruct.edges,layer1);
layer1map = - ones(1,size(grayStruct.nodes,2));
layer1map(layer1) = [1:length(layer1)];

nodes1 = layer1Struct.nodes;
edges1 = layer1Struct.edges;
layer1Struct.layer1 = layer1;
layer1Struct.layer1map = layer1map;

layer1Struct.dist = [];

if exist('h'), close(h); end

return;
