function imHandle = myShowImage(in, imageSize, mymin, mymax) 
% 
% myShowImage(inImageVector,imageSize,mymin,mymax)
%
% AUTHOR:  Engel
% PURPOSE:  Deal with the color maps and display an image via
% RefreshScreen, mainly.
% 
% 

% in = anatimage;
% imageSize = imSize;
% 
% 06/19/97 ll, abp updated to 5.0
% 
global axisflag

if (nargin < 4)
  global slimin slimax;
  if ~isempty(slimin)
    mymin = max(in)*get(slimin,'value');
  else
    mymin = min(in);
  end
  if ~isempty(slimax)
    mymax = max(in)*get(slimax,'value');
  else
    mymax = max(in);
  end
end

if (mymin >= mymax)
   mymax = mymin + .01;
end

%mymin
%mymax

regimage = (in >= 0);
low = ((in < mymin) & regimage);
in(low) = mymin*ones(1,sum(low));
in(in>mymax) = mymax*ones(1,sum(in>mymax));

% 7/02/97 Lea updated to 5.0
%
if ~isempty(in(regimage))
   sim = scale(in(regimage),1,128);
   in(regimage) = sim;
end

in(~regimage) = -in(~regimage)+128;

in = reshape(in,imageSize(1),imageSize(2));
imHandle = image(in);

% Image position is set with respect to the slides and buttons. 
%
set(gca,'Position',[.15 .15 .7 .7])
axis image

if ~axisflag
  axis off
end


return;




