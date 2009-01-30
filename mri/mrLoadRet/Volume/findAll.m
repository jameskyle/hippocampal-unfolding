function x = findAll(v1,v2)

%Finds intersection of the elements in v1 and v2.
%Return values are in terms of indices to v2. 
%So, v2(x) are the actual values in the intersection.
%
%Note: findAll is not commutative: findAll(v1,v2) ~= findall(v2,v1)

%9/30/96  gmb bw  Wrote it.
v1 = v1(:);
v2 = v2(:);

mx=max(v2);
mn=min(v2);
tmp = zeros(1,mx-mn+1);

goodv1 = v1(v1<=mx & v1>=mn)-mn+1;
tmp(goodv1)=tmp(goodv1)+1;
x=find(tmp(v2-mn+1));
clear tmp


%x = [];
%for l = v1
%  tmp = find(v2==l);
%  x = [x;tmp];
%end

