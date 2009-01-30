function tmpImage = mrShowNodes(tmpImage,nodesInPlane,markedNodes,x,y,color);
% Finds the marked nodes in the current plane and updates tmpImage to display
% the marked nodes in the desired color
%
% 02.27.98 SJC
%

if (length(markedNodes) ~= 0)

  [v, idx, dummy] = intersect(nodesInPlane,markedNodes);
  
  if ~isempty(idx)
    % These are the markedNodes in the current plane
    selectedX = x(idx);
    selectedY = y(idx);
    
    % Show the markedNodes in the current plane
    tmpImage = replaceLocs(tmpImage,selectedY,selectedX,color);
  end
end