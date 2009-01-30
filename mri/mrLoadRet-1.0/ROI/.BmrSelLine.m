function fulpts = mrSelLine(curImage,curSize,selpts,curAnat)
%
% fulpts = mrSelLine(curImage,curSize)
%
%	Allows the user to define a region of interest by selecting one or
% more lines on the anatomy image.  The left mouse button defines a starting 
% point for the line.  Pressing the left button again selects the second point
% selecting all point in between.  The middle button selects the second point
% erasing all intermediate points.  The right button exits the function.
% 
% mrSelLine returns the series of points which comprise the selected line(s).
% Points given are indices into the curImage vector.
%
%    Started by B. Wandell, 06.28.93
%    

button = 0;
npts = 0;
x=[];
y=[];
while button ~=3
  [newx newy button] = ginput(1);
  if button~=3
    npts = npts+1;
    x(npts)=round(newx);
    y(npts)=round(newy);
    if (npts>1)
      %determine points on the line between the last point
      %and the newest one.
      if (x(npts-1) ~= x(npts)) 	%not vertical
	line_x = x(npts-1):sign(x(npts)-x(npts-1)):x(npts);
	slope = (y(npts)-y(npts-1))/(x(npts)-x(npts-1));
	line_y = round(y(npts)-1 + slope * (line_x - x(npts-1)));
	selpts = [selpts,[line_y + (line_x-1)*curSize(1);curAnat*ones(1,length(line_x))]];
      end
    end
  end
end
 





