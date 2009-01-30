function FiniteNodes = mrFindGrayPerimeter(layer1Struct,volStruct,class)
%

nPoints = size(layer1Struct.nodes,2);

FiniteNodes = [];

for ii = 1:nPoints
  if (rem(ii,1000) == 0)
    fprintf('Point %d out of %d...\n',ii,nPoints);
  end
  loc = layer1Struct.nodes(1:3,ii);
  x = max(1,loc(1)-1):min(class.header.xsize,loc(1)+1);
  y = max(1,loc(2)-1):min(class.header.ysize,loc(2)+1);
  z = max(1,loc(3)-1):min(class.header.zsize,loc(3)+1);
  data = class.data(x,y,z);
  if ~isempty(find(data == class.type.csf))
     FiniteNodes = [FiniteNodes ii];
  end
end

layer1Struct.dimdist = volStruct.dimdist;

FiniteNodes = [FiniteNodes mrGetCutPerimeter(layer1Struct,FiniteNodes)];

minDist = min(layer1Struct.dimdist);
% All the points that are on the boundaries of the volume of interest are
% also part of the perimeter, and also the points that are within minDist
% of these points (to make sure we get a connected perimeter).
%
Xidx = find((layer1Struct.nodes(1,:) <= (class.header.voi(1))+1) | ...
	    (layer1Struct.nodes(1,:) >= (class.header.voi(2)-1)));
tempX = [];
for ii = 1:length(Xidx)
  distX = mrManDist(layer1Struct.nodes,layer1Struct.edges,Xidx(ii),...
  		layer1Struct.dimdist,-1,2*minDist);
  tempX = [tempX find(distX > 0)];
end
Xidx = [Xidx tempX];

Yidx = find((layer1Struct.nodes(2,:) <= (class.header.voi(3)+1)) | ...
	    (layer1Struct.nodes(2,:) >= (class.header.voi(4)-1)));
tempY = [];
for ii = 1:length(Yidx)
  distY = mrManDist(layer1Struct.nodes,layer1Struct.edges,Yidx(ii),...
  		layer1Struct.dimdist,-1,2*minDist);
  tempY = [tempY find(distY > 0)];
end
Yidx = [Yidx tempY];

Zidx = find((layer1Struct.nodes(3,:) <= (class.header.voi(5)+1)) | ...
	    (layer1Struct.nodes(3,:) >= (class.header.voi(6)-1)));
tempZ = [];
for ii = 1:length(Zidx)
  distZ = mrManDist(layer1Struct.nodes,layer1Struct.edges,Zidx(ii),...
  		layer1Struct.dimdist,-1,2*minDist);
  tempZ = [tempZ find(distZ > 0)];
end
Zidx = [Zidx tempZ];

perimeterIdx = [Xidx Yidx Zidx];

FiniteNodes = unique([FiniteNodes perimeterIdx]);

FiniteNodes = mrLargestConnectedGroup(FiniteNodes,layer1Struct);

return