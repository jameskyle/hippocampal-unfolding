% mrSelPoints2(curImage,curSize)
%
%    Select a set of points from the current image by clicking.
%    left mouse button -- selects a point
%    middle mouse button -- deletes a point
%    right mouse button -- exits
%
%    Started by B. Wandell, 06.28.93
% 

function fulpts = mrSelPoints2(curImage,curSize)

% Variable Declarations
num = 0;		% The number of points selected
ord = [];		% Matrix of selected points (each nonzero entry
			%    gives the order in which the corresponding 
			%    point was selected.
fulpts = [];		% Matrix of selected points (1=selected, 0=not selected).
oldImage = [];		% A copy of the image prior to point selection,
			%    used for erasing selected points.
thept = 0;		% Index into the curImage vector corresponding to
			%    the selected point
dum = 0;		% Involved with sorting the selected points
arrang = 0;		% Involved with sorting the selected points


imHand = myShowImage(curImage, curSize);
axHand = gca;
curImage = get(imHand,'CData');
ord = zeros(curSize(1),curSize(2));
fulpts = zeros(curSize(1),curSize(2));
oldImage = curImage;		% For erasing
num = 1;
while 1 == 1
%  waitforbuttonpress;
%  pt = get(axHand, 'CurrentPoint')
%  x =  pt(2,1);  y =  pt(2,2);  but =  pt(2,3);
  [x,y,but] = mrGinput(1,'cross');
  x = floor(x); y = floor(y);
  fulx = x;
  fuly = y;
  if x <= curSize(2) & y <= curSize(1) & x > 0 & y > 0
     thept = fuly+(fulx-1)*curSize(1);
     if but == 1
       fulpts(fuly,fulx) = 1;
       ord(fuly,fulx) = num;
       curImage(thept) = 999;		% blue
       num = num + 1;
     elseif but == 2
       fulpts(fuly,fulx) = 0;
       curImage(thept) = oldImage(thept);
     elseif but == 3
       break
     end
     set(imHand,'CData',curImage);
  else
   s = sprintf('Out of Range: %d %d',x,y)
  end
end

fulpts = reshape(fulpts,1,prod(size(fulpts)));
ord = reshape(ord,1,prod(size(fulpts))) .* fulpts;
dum = (ord == 0);
ord(dum) = 99999.*ones(sum(dum),1);
[srt, arang] = sort(ord);
fulpts = arang(1:sum(fulpts));









