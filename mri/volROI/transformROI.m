function newVolROI = transformROI(volROI,Xform,sampRate)
% newvolROI = transformROI(volROI,Xform,sampRate)
%
% 
% volROI is 4xN where last row holds the alpha values (partial volume)
% Xform is 4x4 homogeneous transform
% sampRate is 3-vector, supersampling rate for each dimension

% tmpVolROI uses last entry for homogenous coord
tmpVolROI=ones(4,size(volROI,2));
tmpVolROI(1:3,:)=volROI(1:3,:);

tmpVolROI = Xform*tmpVolROI;
minPos = [min(tmpVolROI(1,:));min(tmpVolROI(2,:));min(tmpVolROI(3,:));1];
minPos = round(minPos)-[3,3,3,0]';
maxPos = [max(tmpVolROI(1,:));max(tmpVolROI(2,:));max(tmpVolROI(3,:));1];
maxPos = round(maxPos)+[3,3,3,0]';
dims = maxPos(1:3)-minPos(1:3)+ones(3,1);

accum = zeros(1,prod(dims));

xoffsets=[-.5+1/(2*sampRate(1)):1/sampRate(1):.5-1/(2*sampRate(1))];
yoffsets=[-.5+1/(2*sampRate(2)):1/sampRate(2):.5-1/(2*sampRate(2))];
zoffsets=[-.5+1/(2*sampRate(3)):1/sampRate(3):.5-1/(2*sampRate(3))];

alpha = volROI(4,:)/prod(sampRate);

for xoff=xoffsets
  for yoff=yoffsets
    for zoff=zoffsets
      tmpVolROI(1:3,:)=volROI(1:3,:)+[xoff;yoff;zoff]*ones(1,size(volROI,2));
      tmpVolROI=Xform*tmpVolROI;
      coords=round(tmpVolROI(1:3,:))-minPos(1:3)*ones(1,size(tmpVolROI,2));
      indices=mrVcoord(coords',dims([2,1])');
      % Next line is busted because an index can appear twice in indices
      % accum(indices)=accum(indices)+alpha;
      for jj=1:length(indices)
      	accum(indices(jj))=accum(indices(jj))+alpha(jj);
      end
      
    end
  end
end
  
% build newVolROI
indices=find(accum);
newVolROI=zeros(4,length(indices));
newVolROI(1:3,:)=mrVcoord(indices',dims([2,1])')'+ ...
    minPos(1:3)*ones(1,size(newVolROI,2));
newVolROI(4,:)=accum(indices);






