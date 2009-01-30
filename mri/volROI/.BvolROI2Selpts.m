function selpts = volROI2Selpts(volROI,numofanats,curSize,rot,trans,scaleFac,pVolThresh,sampRate)

if ~exist('pVolThresh')
  pVolThresh = 0.1;
end

if ~exist('sampRate')
  sampRate = [4,4,4];
end

%Transform volROI to the inplanes, and threshold the 
%partial volume.
Xform = inplane2VolXform(rot,trans,scaleFac);
volROI = transformROI(volROI,inv(Xform),sampRate);
volROI = volROI(:,volROI(4,:)>=pVolThresh);
%Creates selpts from the transformed volROI.
selpts = zeros(2,size(volROI,2));
selpts(2,:) = volROI(3,:);
volROI(3,:)=ones(size(volROI(3,:)));
selpts(1,:)=mrVcoord(volROI(1:3,:)',curSize)';
