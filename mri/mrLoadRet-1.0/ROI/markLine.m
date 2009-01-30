function binImage = markLine(imSize,x,y)
%binImage = markLine(imSize,x,y)
%
%Generates a binary image of a line from x(1),y(1) to x(2),y(2)
%
% imSize:	size of image [m,n]
% x:		[x1,x2] start and end x values
% y:		[y1,y2] start and end y values
% binImage      binary image of line.
%
%  Example:
%    line_image=markLine([50,50],[10,40],[10,40]);
%    figure(1)
%    colormap(gray);
%    image(64*line_image);

  binImage = zeros(imSize);
  x = floor(x); y = floor(y);
  slope = (y(2)-y(1))/(x(2)-x(1));    
				% Actually the negative of the slope since
				% Y is increasing from top to bottom.
				    
  if(abs(slope) < 1)	% More unique x's than y's
	  dx = sign(x(2)-x(1))*[0:(round(max(x)-min(x)))];
	  dy = round(slope*dx);
  else			% More unique y's than x's
	  dy = sign(y(2)-y(1))*[0:(round(max(y)-min(y)))];
	  dx = round((1/slope)*dy);
  end
  if( x(1) <= imSize(2) & y(1) <= imSize(1) & x(1) > 0 & y(1) > 0 & ...
	x(2) <= imSize(2) & y(2) <= imSize(1) & x(2) > 0 & y(2) > 0 )
	  x = x(1); y =y(1); 
	  for i = (1:length(dx))
		  a = dx(i); b = dy(i);
        	  binImage(y+b,x+a) = 1;
	  end
  else
      disp('Point out of range');
  end

