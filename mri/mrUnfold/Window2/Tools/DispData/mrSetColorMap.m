function out = mrSetColorMap(cMap,h_fig)
% function out = setColorMap(cMap,h_fig)
%
% 07.10.98  SJC
%
% PURPOSE:	Adds the color map loaded with the data to be overlaid
%		on the gray matter to the current color map
%
% ARGUMENTS:	cMap	color map to be added
%		h_fig	handle to figure whose color map is to be changed
%
% RETURNS:	nothing
%

% (1) Get the current colormap
%
map = get(h_fig,'Colormap');

% (2) Eliminate any colors beyond 198 added to the colormap (from previous data sets)
if (size(map,1) > 198)
  map(199:size(map,1),:) = [];
end

% (3) Add the rgb values of the data points to the end of the current color map.
%
map = [map; cMap./255];

set(h_fig,'Colormap', map);

return;