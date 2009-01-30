% mrCreateCut.m
% script
%
% AUTHOR:	SJC
% DATE:		05.12.98
% PURPOSE:	User interface for generating cuts in the first layer of gray matter
%
% MODIFICATIONS:
% 06.30.98 SJC	Eliminated the clearing of a previous cut when a new one is created.
%		The new cut is now simply appended to the old cut, so that the user
%		can have several cuts in one cut file (they will not be distinct).
% 07.10.98 SJC	Changed name from mrVolCut.m to mrCreateCut.m
%		Changed names of other supporting functions too.
%		Added extra flag for displaying loaded data.
%

% If the first layer nodes and edges have not been selected, select them from
% all the gray nodes and edges or load them from file
if (isempty(layer1Struct.nodes) | isempty(layer1Struct.edges))
  layer1Struct = mrSelectLayer1(grayStruct,grayMatter,anatomy);
end

if ((selectedNode.index ~= -1) & isempty(layer1Struct.dist))
  layer1Struct.dist = mrManDist(layer1Struct.nodes,layer1Struct.edges,layer1Struct.layer1map(selectedNode.index),volStruct.dimdist,-1);
end


% Show the current start point and the selected unfold area if they have been set
if ((selectedNode.index ~= -1) & (volStruct.radius > 0))
  displayStruct.flags = [-1 -1 1 -1 -1];
else
  displayStruct.flags = [-1 1 -1 -1 -1];
end

mrChangeImageScript;

%%%%%%%%% Create GUI for creating cuts %%%%%%%%%%

% Contains colormap for the gui
load mrCreateCut

cut_fig = figure('Units','points', ...
	'Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'Position',[213.3 575 193.3 155], ...
	'Tag','Fig1');
set(cut_fig,'MenuBar','none');

title = uicontrol('Parent',cut_fig, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'FontSize',12, ...
	'ListboxTop',0, ...
	'Position',[74.6 135 44.1 15], ...
	'String','Cuts', ...
	'Style','text', ...
	'Tag','StaticText2');

%%%%%%%%%% BUTTONS %%%%%%%%%%

selectNodes_btn = uicontrol('Parent',cut_fig, ...
	'Units','points', ...
	'BackgroundColor',[0.701960784313725 0.701960784313725 0.701960784313725], ...
	'ListboxTop',0, ...
	'Position',[32.3 105 130 25], ...
	'String','Select Cut Path Nodes', ...
	'Tag','Pushbutton1',...
	'Interruptible','on',...
	'Callback',[...
	  'setVisiblesOff;,'...
	  'if ~isempty(layer1Struct.dist),'...
	    'displayStruct.flags = [-1 -1 1 -1 -1];,'...
	    'mrChangeImageScript;,'...
	    'isDone = 0;,'...
	    'selectedNodes = [];,'...
	    'while (isDone == 0),'...
	      'figure(h_fig2),'...
	      '[c r button] = ginput(1);,'...
	      'c = round(c); r = round(r);,'...
 	      '[nextNode, isDone] = addCutPathNode(c,r,button,displayStruct,layer1Struct,volStruct,h_fig2);,'...
	      'selectedNodes = [selectedNodes nextNode];,'...
	      '[selectedNode,displayStruct.flags(3),imgStruct] = mrOverlayDist(volStruct,displayStruct,layer1Struct,selectedNode,selectedNodes,mVoxelsStruct,h_fig2);,'...
	    'end,'...
	    '[displayStruct.flags(3), currentCut] = mrSelectCut(selectedNodes,layer1Struct,volStruct);,'...
	    'cutNodes = [cutNodes currentCut];',...
	    'mrChangeImageScript;',...
	  'else,'...
	    'setVisiblesOn;',...
	    'disp(''ERROR: Unfold area not selected.  Please select a start point and try again.'');,'...
	  'end,'...
	  'setVisiblesOn;']);

save_txt = uicontrol('Parent',cut_fig,...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'ListboxTop',0, ...
	'Position',[47.6 85 97.2 15], ...
	'String','Cut filename:', ...
	'Style','text',...
	'Tag','StaticText3');

save_edit = uicontrol('Parent',cut_fig,...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[42.6 65 107.2 20], ...
	'String',[grayMatter.file '_cutFile'], ...
	'Style','edit',...
	'Tag','EditText3');

save_btn = uicontrol('Parent',cut_fig, ...
	'Units','points', ...
	'BackgroundColor',[0.701960784313725 0.701960784313725 0.701960784313725], ...
	'ListboxTop',0, ...
	'Position',[47.6 35 97.2 25], ...
	'String','Save Cut', ...
	'Tag','Pushbutton1',...
	'Callback','mrSaveCut');

clear_btn = uicontrol('Parent',cut_fig, ...
	'Units','points', ...
	'BackgroundColor',[0.701960784313725 0.701960784313725 0.701960784313725], ...
	'ListboxTop',0, ...
	'Position',[47.6 5 97.2 25], ...
	'String','Clear Cut', ...
	'Tag','Pushbutton1',...
	'Callback',['mrClearCut;,'...
	  'mrChangeImageScript;']);
