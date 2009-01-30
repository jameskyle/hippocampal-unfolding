function mVoxelsStruct = addMarkedRect(rect,mVoxelsStruct,displayStruct,grayStruct,volStruct,h_fig2);
% Takes location from ginput, finds nearest gray matter node in current slice to it, and removes it
% from the list of marked voxels if it is marked.
%
% 01.15.98 SJC

% Modified 02.27.98 SJC-added six different edit areas
%

switch displayStruct.activeSliceOri
  case 1,				% SAGITTAL grayNode indices
	grayNodeIndex = 3;
	% Create a list of indexes into grayStruct.nodes which have graymatter in this slice
	l = find(grayStruct.nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri));
	x = grayStruct.nodes(1,l); y  = grayStruct.nodes(2,l);
  case 2,				% AXIAL
	grayNodeIndex = 2;
	l = find(grayStruct.nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri));
	x = grayStruct.nodes(1,l); y = grayStruct.nodes(3,l); 
  case 3,				% CORONAL 
	grayNodeIndex = 1;
	l = find(grayStruct.nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri));
	x = grayStruct.nodes(2,l); y = grayStruct.nodes(3,l); 
  otherwise,
	disp('ERROR mrVolSelectLine:  Invalid slice orientations');
	return;
end

% Find which area is active for editing
switch mVoxelsStruct.selected
  case 1,
    mVoxels = 'mVoxelsStruct.Area1';
  case 2,
    mVoxels = 'mVoxelsStruct.Area2';
  case 3,
    mVoxels = 'mVoxelsStruct.Area3';
  case 4,
    mVoxels = 'mVoxelsStruct.Area4';
  case 5,
    mVoxels = 'mVoxelsStruct.Area5';
  case 6,
    mVoxels = 'mVoxelsStruct.Area6';
  otherwise,				% None
    return;
end

c = [rect(1),rect(1) + rect(3)];
r = [rect(2),rect(2) + rect(4)];

if (displayStruct.activeSliceOri ~= 1)
  temp = c;
  c = r;
  r = temp;
end

% Figure out the closest x,y to the c,r 
% 
[v corners(1)] = min(abs(x - c(1)) + abs(y - r(1)));
[v corners(2)] = min(abs(x - c(1)) + abs(y - r(2)));
[v corners(3)] = min(abs(x - c(2)) + abs(y - r(1)));
[v corners(4)] = min(abs(x - c(2)) + abs(y - r(2)));

selectedX = find((x > c(1)) & (x < c(2)));
selectedY = find((y > r(1)) & (y < r(2)));
idx = intersect(selectedX,selectedY);

% 'idx' is where they are on the plane
% 'l(idx) are indices into their data in 'grayNodes'
nextVoxels = l([corners,idx]);

% Check to see if voxels are already marked
cmd = ['isempty(' mVoxels ')'];
if ~eval(cmd)
  cmd = ['[v dummmy repeats] = intersect(' mVoxels ',nextVoxels);'];
  eval(cmd);
else
  repeats = [];
end

% If any voxels are already marked, do not add to marked Voxels list
if ~isempty(repeats)
  nextVoxels(repeats) = [];
end

if ~isempty(nextVoxels)
  cmd = [mVoxels '=[' mVoxels ', nextVoxels];'];
  eval(cmd);
end

