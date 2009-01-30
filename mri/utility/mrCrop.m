function [crop,cropSize,xyLines] = mrCrop
%
%          [crop cropSize,xyLines] = mrCrop
%
%AUTHOR:  Probably Wandell
%DATE:    A long, long time ago.
%
%PURPOSE
%  Permit the user to select a region visually by cropping the image
%  in the current figure.
%
%BUGS:
%  We use the routine cropImage (in imageCalc directory) to actually
%  select out the data, and we use this routine to click on the image.
%  We should integrate the two procedures.
%
%SEE ALSO:  cropImage to extract the data from the image.
%

% 1/26/97 gmb any two corners will define rectangle 
%         (not just upper left and lower right)

xlim=get(gca,'XLim');
ylim=get(gca,'YLim');
xt=xlim(1)+diff(xlim)*0.025;
yt=ylim(1)+diff(xlim)*[0.05,0.1];	
msg(1) =text(xt,yt(1),'Middle button to clip again','Color','r');
msg(2) =text(xt,yt(2),'Right button when finished','Color','r');

%t1 = text(3,4,'Click upper left');
%t2 = text(3,8,'then lower right');

crop = fix(ginput(2));

%flip signs of crop so corners are upper left and lower right
for i=1:2
  if crop(2,i) < crop(1,i)
    crop(:,i)=flipud(crop(:,i));
  end
end

cropSize = fliplr(crop(2,:) - crop(1,:) + 1);

xyLines = overlayBox(crop);

delete(msg(1)); 
delete(msg(2));


