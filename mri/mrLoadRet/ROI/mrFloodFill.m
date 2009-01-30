function [inPoly] = mrFloodFill(inPoly,imSize,startPt);
%
% [inPoly] = mrFloodFill(inPoly,imSize,startPt);
%
% mrFloodFill uses a simplisitic fill algorithm to fill a region.
% inPoly is a 2-D array where 1=fill, 0=empty


for i=1:2
 % Initialize to startPt
 xs=floor(startPt(1)); ys=floor(startPt(2));
 x=xs;
 switch i	% up versus down
 	case 1,
 	yi=1;y=ys;
 	case 2,
 	yi=-1;y=ys-1;
 end
 while((inPoly(y,x)==0) & (y>1) & (y<imSize(1)))
	x=xs;
	% Fill Right
	while((inPoly(y,x)==0) & (x<imSize(2)))
		inPoly(y,x)=1;
		x=x+1;
	end
	xr=x;
	% Fill Left
	x=xs-1;
	while((inPoly(y,x)==0) & (x>1))
		inPoly(y,x)=1;
		x=x-1;
	end
	xl=x;
	y=y+yi;
	xs=round((xl+xr)/2);
	x=xs;
 end
end
