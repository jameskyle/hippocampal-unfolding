% READGRAYGRAPH
%
%    [nodes, edges, vSize] = readGrayGraph(filename)
% 
% AUTHOR:  Teo
% DATE:    1996
% PURPOSE:
%    Read gray matter graph put out by mrGray
% 
% ARGUMENT:
%   name of gray graph file written by mrGray
% 
% RETURNS:
% nodes:  8xN array of 
%    Nx(x,y,z,num_edges,edge_offset,layer,dist,pqindex).
% edges:  1xM array of node indices.  The edge_offset of
%    each node points into the starting location of its set
%    of edges.
% where N, M are the number of nodes, edges in the graph.
% vSize = size of the original volume of data containing the anatomicals
%
function [nodes, edges, vSize] = readGrayGraph(filename)

fid = fopen(filename);

% Read xsize, ysize, zsize.
[sizes, cnt] = fread(fid, [1 3], 'int');

% [rows, cols, planes]; [ysize, xsize, zsize].
vSize = [sizes(2), sizes(1), sizes(3)];

% Read in number of nodes and edges.
[sizes, cnt] = fread(fid, [1 2], 'int');

% Read header.
num_nodes = sizes(1);
num_edges = sizes(2);

% Read nodes.
nodes = fread(fid, [6 num_nodes], 'int');

% Offset edge_offset by 1 because MATLAB implements arrays
% with base 1 *@#!#!
nodes(5,:) = nodes(5,:) + 1;

% Add two additional attributes for miscellaneous use.
% These are used by the shortest path algorithm to store
% intermediate distance calculations and to mark position
% in the priority queue.
nodes = [nodes ; zeros(2,num_nodes)];

% Read edges.
edges = fread(fid, [1 num_edges], 'int');

% Offset all node indices by 1 because MATLAB implements arrays
% with base 1 *@#!#!
edges = edges + 1;

fclose(fid);

