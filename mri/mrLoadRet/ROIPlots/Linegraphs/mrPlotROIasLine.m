function graphWin= mrPlotROIasLine(dat,selpts,curSer,curSize,anatmap,kind,graphWin,loadRetWin)
%graphWin = mrPlotROIasLine(dat,selpts,curSer,curSize,anatmap,kind,graphWin,loadRetWin)
%
%Plots data in the ROI in the current plane, assuming that the
%ROI is a sequence of pixels along a line or sequence of lines.
% 
% inputs: dat,kind if kind ==1  plot correlations (dat = co at function call)
%                  if kind ==2  plot amplitudes   (dat = amp)
%		   if kind ==3  plot phase        (dat = ph)
%          selpts,curSer,curSize,anamap - defined by usual
%          mrLoadRet conventions

% 1/23/97  gmb   Plots in a second window

% pull out id's of selpts in the current plane
line_id = selpts(1,selpts(2,:)==anatmap(curSer));

%y values on plot are appropriate subset of the variable 'dat'
y = dat(curSer,line_id);

%special case for phase data:
if kind ==3
  y=unwrap(y);
  y=y*180/pi;
end

%figure out the x-axis by the coordinates in selpts
line_pos = mrVcoord(line_id',curSize);
foo = diff(line_pos);
dx = sqrt(foo(:,1).^2 + foo(:,2).^2);
x = [0;cumsum(dx)];

%determine y-axis label
if kind ==1
  ytext='Correlation';
elseif kind ==2
  ytext = 'Amplitude';
else
  ytext = 'Phase (deg)';
end

if exist('graphWin')
  if ~isempty(graphWin)
    figure(graphWin);
  else
    graphWin=figure;
  end
  set(gcf,'Name',['ROI as line: ',ytext]);
end


%hide the colorbar
mrColorBar(0,'off');

%make the plot
plot(x,y,'g','LineWidth',2);
hold on
plot(x,y,'bo','LineWidth',2);
xlabel('Distance along line (pixels)');
ylabel(ytext)
grid
hold off
if exist('loadRetWin')
  figure(loadRetWin);
end
