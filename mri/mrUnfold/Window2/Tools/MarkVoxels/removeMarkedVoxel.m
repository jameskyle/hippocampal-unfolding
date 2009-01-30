function [mVoxels, isDone] = removeMarkedVoxel(c,r,button,mVoxels,displayStruct,grayStruct,volStruct,h_fig2);
% Takes location from ginput, finds nearest gray matter node in current slice to it, and removes it
% from the list of marked voxels if it is marked.
%


switch displayStruct.activeSliceOri
  case 1,				% SAGITTAL grayNode indices
	grayNodeIndex = 3;
	% Create a list of indexes into grayStruct.nodes which have graymatter in this slice
	l = find((grayStruct.nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri)) & (grayStruct.nodes(6,:) == 1));
	x = grayStruct.nodes(1,l); y  = grayStruct.nodes(2,l);
  case 2,				% AXIAL
	grayNodeIndex = 2;
	l = find((grayStruct.nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri)) & (grayStruct.nodes(6,:) == 1));
	x = grayStruct.nodes(1,l); y = grayStruct.nodes(3,l); 
  case 3,				% CORONAL 
	grayNodeIndex = 1;
	l = find((grayStruct.nodes(grayNodeIndex,:) == displayStruct.iNumber(displayStruct.activeSliceOri)) & (grayStruct.nodes(6,:) == 1));
	x = grayStruct.nodes(2,l); y = grayStruct.nodes(3,l); 
  otherwise,
	disp('ERROR mrVolSelectLine:  Invalid slice orientations');
	return;
end


if (displayStruct.activeSliceOri == 3)
  temp = c;
  c = r;
  r = temp;
end

% Figure out the closest x,y to the c,r 
% 
[v idx] = min(abs(x - c) + abs(y - r));

% 'idx' is where they are on the plane
% 'l(idx) are indices into their data in 'grayNodes'
nextVoxel = l(idx);

% Check to see if this voxel is already marked
repeats = find(mVoxels == nextVoxel);

% If voxel is marked, remove it from the marked voxels list
if ~isempty(repeats)
  mVoxels(repeats) = [];
end

% Checking to see if right button was pressed
%
if (button == 3)
  isDone = 1;
else
  isDone = 0;
end
