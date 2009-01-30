function Xform = inplane2VolXform(rot,trans,scaleFac)
%Xform = inplane2VolXform(rot,trans,scaleFac)
%returns 4x4 homogeneous tranform that tranforms from inplane to
%volume.

A=diag(scaleFac(2,:))*rot*diag(1./scaleFac(1,:));
b = (scaleFac(2,:).*trans)';

Xform = zeros(4,4);
Xform(1:3,1:3)=A;
Xform(1:3,4)=b;
Xform(4,4)=1;

%for debugging....
%Xform=eye(4);
