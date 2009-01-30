%mrUpdateStartPoint.m
% script
% 
% AUTHOR:  Poirson
% DATE:    03.19.97
% PURPOSE:  Set the node for growing gray matter.  
% 	    User can enter either a node number or a [sag,ax,cor] vector.
%           If user hits return, then current 'selectNode' stands.
% HISTORY: 
% 01.07.98 SJC	grouped related variables into structures
% 03.23.98 SJC	restricted selected node to be on the first layer
% 05.25.98 SJC	rewrote function to be a gui callback (script), so that it
%		is called after the node location is modified in the mrVol
%		Display window

% User updated node number
if (updated == 'idx')
  temp = str2num(get(Node_edit,'String'));
  % Check to see if node is on the first layer
  if (grayStruct.nodes(6,temp) == 1)
    selectedNode.index = temp;
    % Now tell us where it is [sagittal,axial,coronal] -wise.
    % The 'selectedNode.index' is actually a column number in
    % the structure 'grayStruct.nodes'.
    selectedNode.S = grayStruct.nodes(3,selectedNode.index);
    selectedNode.A = grayStruct.nodes(2,selectedNode.index);
    selectedNode.C = grayStruct.nodes(1,selectedNode.index);
    mrChangeImageScript;
  else
    errordlg('\nNode not on first layer; node not selected.\n');
  end

% User updated sagittal, axial, or coronal location
elseif (updated == 'loc')
  temp.S = str2num(get(S_edit,'String'));
  temp.A = str2num(get(A_edit,'String'));
  temp.C = str2num(get(C_edit,'String'));
  
  % Get the node index that matches the specified sagittal, axial, and coronal locations
  [i,j] = find( (grayStruct.nodes(1,:) == temp.C) & (grayStruct.nodes(2,:) == temp.A )& (grayStruct.nodes(3,:) == temp.S) );
  if (isempty(j))
    errordlg('No gray matter at this brain location; node not selected.\n');
  else
    % Find out if node is on the first layer
    if (grayStruct.nodes(6,j) == 1)
      selectedNode.index = j;
      selectedNode.S = temp.S;
      selectedNode.A = temp.A;
      selectedNode.C = temp.C;
      mrChangeImageScript;
    else
      errordlg('\nNode not on first layer; node not selected.\n');
    end
  end
end

noVol = -1;
grayStruct.dist = mrManDist(grayStruct.nodes,grayStruct.edges,selectedNode.index,volStruct.dimdist,noVol);
layer1Struct.dist = mrManDist(layer1Struct.nodes,layer1Struct.edges,layer1Struct.layer1map(selectedNode.index),volStruct.dimdist,noVol);

% Update guis
set(S_edit,	'String',num2str(selectedNode.S));
set(A_edit,	'String',num2str(selectedNode.A));
set(C_edit,	'String',num2str(selectedNode.C));
set(Node_edit,	'String',num2str(selectedNode.index));

clear temp i j

