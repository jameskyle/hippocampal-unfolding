function [mVoxelsStruct, isDone] = addMarkedVoxel(c,r,button,mVoxelsStruct,displayStruct,grayStruct,volStruct,h_fig2);
% Takes location from ginput, finds nearest gray matter node in current slice to it, and adds it
% to the list of marked voxels.
%
% 01.15.98 SJC

% Modified 02.27.98 SJC-added six different edit areas
%

if (button ~= 3)
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

  if (displayStruct.activeSliceOri ~= 1)
    temp = c;
    c = r;
    r = temp;
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

  % Figure out the closest x,y to the c,r 
  % 
  [v idx] = min(abs(x - c) + abs(y - r));

  % 'idx' is where they are on the plane
  % 'l(idx) are indices into their data in 'grayNodes'
  nextVoxel = l(idx);

  % Check to see if this voxel is already marked
  cmd = ['isempty(' mVoxels ')'];
  if ~eval(cmd)
    cmd = ['repeats = find(' mVoxels ' == nextVoxel);'];
    eval(cmd);
  else
    repeats = [];
  end

  if ((button == 1) & isempty(repeats))		% ADD VOXEL
    % If voxel is not marked, add it to the marked voxels list
    cmd = [mVoxels '=[' mVoxels ', nextVoxel];'];
    eval(cmd);

  elseif ((button == 2) & ~isempty(repeats))
    % If voxel is marked, remove it from the marked voxels list
    cmd = [mVoxels '(repeats) = [];'];
    eval(cmd);
  end

  isDone = 0;

else
  % Button 3 was pressed, do nothing
  isDone = 1;
end
