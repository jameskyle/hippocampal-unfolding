function [m,sd,num]=mrMeanAmp(selpts,amp,ph,pWindow,numofanats);
%[m,sd,num]=mrMeanAmp(selpts,amp,ph,pWindow,numofanats);
%
%Calculates mean, sd and number for the variable 'amp' 
%for pixels that are in selpts AND in pWindow AND are not zero.

%3/12/96  gmb	wrote it.

numofexps=size(amp,1)/numofanats;
m=zeros(1,numofexps);
sd=m;
num=m;
x=[];

% 7/09/97 Lea updated to 5.0
for j=1:numofexps
	n=0;
	s=0;
	sq=0;
	for i=1:numofanats
		curSer=(i-1)*numofexps+j;
		a=selpts(1,selpts(2,:)==i);
		b=(mrGetInpWindow(ph(curSer,:),pWindow));

		if size(a)>0
			pts=a(b(a)==1);
		else
			pts=[];
		end
		x=amp(curSer,pts);
		if ~isempty(x)
		  x=x(x~=0);
		end
		s=s+sum(x);
		sq=sq+sum(x.^2);
		n=n+length(x);
	end
	m(j)=s/n;
	sd(j)= sqrt((sq- s.^2/n)/(n-1));
	num(j)=n;
end





