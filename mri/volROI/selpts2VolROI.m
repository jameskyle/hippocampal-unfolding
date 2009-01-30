function volROI = selpts2VolROI(selpts,numofanats,curSize,rot,trans,scaleFac,sampRate)

%Turn selpts into 3xn vector

if ~exist('sampRate')
  sampRate = [4,4,16];
end

Xform = inplane2VolXform(rot,trans,scaleFac);

volROI = ones(4,size(selpts,2));
volROI(1:3,:) = mrVcoord(selpts(1,:)',curSize)';
volROI(3,:)=selpts(2,:);

volROI = transformROI(volROI,Xform,sampRate);

