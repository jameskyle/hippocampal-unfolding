function [origin,daty,dat_dist,graphWin] = mrROIdist(dat,kind,curSer,curSize,selpts,anatmap,graphWin,loadRetWin,origin)
% function graphWin = mrROIdist(dat,kind,curSer,curSize,selpts,anatmap,graphWin,loadRetWin)
%
% Produces plots of data (cor,amp or phase) in an ROI as a
% function of distance (computed on pixels in the image) from a
% specified origin.  Use mouse to specify the origin.
%
% To avoid junk pixels, remember to restrict ROI first.
%
% kind = 1 (cor)
%      = 2 (amp)
%      = 3 (ph)
%      = 4 (signed amplitude)
%
% 02/12/98  rmk wrote it

if (nargin<9)

  % specify origin:

  xlim=get(gca,'XLim');
  ylim=get(gca,'YLim');
  xt=xlim(1)+diff(xlim)*0.025;
  yt=ylim(1)+diff(xlim)*[0.05,0.1];
  msg(1) =text(xt,yt(1),'Click button to specify origin','Color','w');

  origin=fix(ginput(1));

  delete(msg(1)); 
end

sel_id = selpts(1,selpts(2,:)==anatmap(curSer));
y = dat(curSer,sel_id);

if (kind==4)
  a=real(y);
  p=imag(y);
  ysz=size(y);
  for i=1:ysz(1)
   for j=1:ysz(2)
     y(i,j)=[a(i,j)*cos(p(i,j)) a(i,j)*sin(p(i,j))]*[cos(pi/5); sin(pi/5)];
   end
  end 
end

% compute distance from origin for selpts

   % convert selpts to x,y co-ordinates:

   selsz=size(sel_id);
   
   for i=1:selsz(2)
     selcoord(i,1)=ceil(sel_id(i)/curSize(1));
     selcoord(i,2)=mod(sel_id(i),curSize(1))+1;
     seldist(i)=dist(origin,selcoord(i,:)');
   end

% plot the data as a fn of distance:


%determine y-axis label
if kind ==1
  ytext='Correlation';
elseif kind ==2
  ytext = 'Amplitude';
elseif kind ==3
  ytext = 'Phase (deg)';
  y=y*180/pi;
else
  ytext = 'Signed Amplitude';  
end

if exist('graphWin')
  if ~isempty(graphWin)
    figure(graphWin);
  else
    graphWin=figure;
  end
  set(gcf,'Name',['ROI as dist: ',ytext]);
end


%hide the colorbar
mrColorBar(0,'off');

xlim=get(gca,'XLim');
ylim=get(gca,'YLim');
xt=xlim(1)+diff(xlim)*0.025;
yt=ylim(1)+diff(xlim)*[0.05,0.1];

daty=y;
dat_dist=seldist;

%make the plot
if (kind==3)
 subplot(2,1,1)
end 
  plot(seldist,y,'o');
  hold on
  set(gca,'FontSize',18);
  xlabel('Distance from origin (pixels)');
  ylabel(ytext)
  xlim=get(gca,'XLim');
  ylim=get(gca,'YLim');
  xt=xlim(1)+diff(xlim)*0.025;
  yt=ylim(1)+diff(ylim)*0.95;
  msg(1) =text(xt,yt(1),['Origin at [',int2str(origin(1)),', ',int2str(origin(2)),']']);
  hold off
if (kind==3)  
  subplot(2,1,2)
  polar(y*(pi/180),seldist,'x');
  set(gca,'FontSize',18);
end  
  
if exist('loadRetWin')
  figure(loadRetWin);
end


   
   
