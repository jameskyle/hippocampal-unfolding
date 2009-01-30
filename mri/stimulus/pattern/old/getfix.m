function img=getfix(img,lo,hi,backcolor)
% fix=getfix(img,[lo],[hi],[backcolor]) creates a fixation point
% optional low and high values are set to 0 and 1 by default.

if (size(img,1)==1 | size(img,2)==1)
	error('getfix: first argument must be image matrix');
end

if (nargin==1) 
	lo=0;
	hi = 255;
	backcolor=127.5;
end

if (nargin==3), backcolor=127.5; ,end

m=size(img,1);n=size(img,2);

s=4; %width of fixation point (try 6)
[x,y]=meshgrid([1:s],[1:s]);

f=hi * ones(size(x));

f([s/4+1:3*s/4],[s/4+1:3*s/4])=lo ...
	*ones(size([s/4+1:3*s/4],[s/4+1:3*s/4]));

g=find(f~=backcolor);

% insert the fixation into 'img'
img(m*(x(g)+floor(n/2-s/2)-1)+y(g)+ceil(n/2-s/2))= f(g);

