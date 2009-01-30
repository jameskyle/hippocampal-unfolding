function [curImage, curSize, curCrop, anat] = mrClipAnatRet(anat, oSize,anatmap,curSer);

%  mrClipAnatRet (anat, curSize)
%
%	Clips the current image and returns curImage, curSize, and curCrop (in that
% order).  The returned values all correspond to the cropped image. 


% Variable Declarations


x = 0;		% X coordinate of mouse click (currently unused)
y = 0;		% Y coordinate of mouse click (currently unused)
button = 0;	% Which button pushed (1,2,3) starting from the left
msg = [0,0];	% Handle to the text object

set(msg,'Units','normalized');

[curImage, curSize, curCrop] = mrClipRet(anat(anatmap(curSer),:), oSize);

while button ~= 3
   xlim=get(gca,'XLim');
   ylim=get(gca,'YLim');
   xt=xlim(1)+diff(xlim)*0.05;
   yt=ylim(1)+diff(ylim)*[0.05,0.1];	
   msg(1) =text(xt,yt(1),'Middle button to clip again');
   msg(2) =text(xt,yt(2),'Right button when finished');
   [x,y,button] = ginput (1);
   if (button == 2)
      [curImage, curSize, curCrop] = mrClipRet(anat(anatmap(curSer),:), oSize);
   end
end

anat = cropSeries(anat,oSize,curCrop);
set(msg,'Visible','off');






