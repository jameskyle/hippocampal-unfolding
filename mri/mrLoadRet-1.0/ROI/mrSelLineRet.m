function [curImage,selpts,originalSelpts] = mrSelLineRet(curImage,curSize,originalSelpts,curAnat)
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
%    Re-written by gmb      9/10/96

originalSize=size(originalSelpts,2);
selpts=[];

xlim=get(gca,'XLim');
ylim=get(gca,'YLim');
xt=xlim(1)+diff(xlim)*0.025;
yt=ylim(1)+diff(xlim)*[0.05,0.1];

oldselpts = selpts;

button = 0;
npts = 0;
x=[];
y=[];
while button ~=3
  [newx newy button] = mrGinput(1,'cross');
  if button~=3
    npts = npts+1;
    x(npts)=round(newx);
    y(npts)=round(newy);
    if (npts>1)
      %determine points on the line between the last point
      %and the newest one.
      if x(npts-1) ~= x(npts) | y(npts-1)~=y(npts)
	%mostly horizontal
	if (abs(x(npts-1)-x(npts)) > abs(y(npts-1)-y(npts)))
	  line_x = x(npts-1):sign(x(npts)-x(npts-1)):x(npts);
	  slope = (y(npts)-y(npts-1))/(x(npts)-x(npts-1));
	  line_y = round(y(npts-1) + slope * (line_x - x(npts-1)));
	else 				%mostly vertical
	  line_y = y(npts-1):sign(y(npts)-y(npts-1)):y(npts);
	  slope = (y(npts)-y(npts-1))/(x(npts)-x(npts-1));
	  line_x = round(x(npts-1) + 1/slope * (line_y - y(npts-1)));
	end
	selpts = [selpts,[line_y + (line_x-1)*curSize(1);curAnat*ones(1,length(line_x))]];
	if exist('handle_list');
	  for i=1:length(handle_list)
	    delete(handle_list(i));
	  end
	end
	handle_list = mrViewROIRet(curSize,selpts,curAnat);
      end
    end
  end
end


%Note: using mrMergeSelpts destroys the order of selected
%      points.  This is indesirable for plotting ROI's as
%      lines, so we'll skip it here and risk having duplicate
%      points in the ROI.
%selpts =  mrMergeSelpts(originalSelpts,selpts);

%Instead, simply append the new points.
selpts = [originalSelpts,selpts];

finalSize=size(selpts,2);
disp([int2str(finalSize-originalSize),' pixels added.']);
