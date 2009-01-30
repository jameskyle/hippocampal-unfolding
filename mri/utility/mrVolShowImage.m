function imgStruct = mrVolShowImage(vData,vSize,displayStruct,h_fig2,imMin,imMax,cmapMax)
% 
% imgStruct = mrVolShowImage(vData,vSize,displayStruct,h_fig2,imMin,imMax,cmapMax)
% 
% AUTHOR: Wandell
% DATE:   03.09.97
% PURPOSE: Display an image from a volume data set
% HISTORY:03.17.97 ABP -- Added view from other orientations
%         11.11.97 SC -- Modified to run on Matlab 5.0
%	  06.02.98 SC -- Added axis positioning
%	  06.03.98 SC,HB Set DataAspectRatios
% TODO:
% 

global axisflag slimin slimax;

% Set up the display image
% 
if (min(size(vData)) == 1)
  % Routine passed one image in dummy structure
  imSize = vSize(1,1:2);
  dispImage = reshape(vData,1,prod(imSize));
else
  % Passed volume of images. Extract one image here
  imSize = vSize(displayStruct.activeSliceOri,1:2);
  dispImage = ExtractVolImage(vData,vSize,displayStruct);
end

if nargin < 7
  cmapMax = 128;
end

if (nargin < 6)
  global slimin slimax;
  if ~isempty(slimin)
    imMin = max(max(max(dispImage)))*get(slimin,'value');
  else
    imMin = min(min(min(dispImage)));
  end

  if ~isempty(slimax)
    imMax = max(max(max(dispImage)))*get(slimax,'value');
  else
    imMax = max(max(max(dispImage)));
  end

end

if (imMin >= imMax)
  imMax = imMin + .01;
end

if nargin < 4
  errordlg('mrVolShowImage requires (at least) five inputs');
end

% Designed for overlays.
% 
regimage = (dispImage >= 0);

% Set the gray levels within the min/max range to the cmapMax range
% 
dispImage(regimage) = truncate(dispImage(regimage),imMin,imMax);
dispImage(regimage) = scale(dispImage(regimage),1,cmapMax);

% Set the overlay values
dispImage(~regimage) = -dispImage(~regimage)+cmapMax;

% Display the image
% 
dispImage = reshape(dispImage,imSize(1),imSize(2));
if (displayStruct.activeSliceOri ~= 1)
  dispImage = dispImage';
end

figure(h_fig2);
imgStruct.imHandle = image(dispImage);
imgStruct.dispImage = dispImage;

% Adjust the image position and size
axis image
p = get(gca,'Position');
imSizeRatio = p(3)/p(4);
p(1) = 0.30;
p(3) = 0.95 - p(1);
p(4) = p(3)/imSizeRatio;
set(gca,'Position',p);
hold on

switch displayStruct.activeSliceOri
 case 1,
  ori = 'Sagittal';
  X1 = [1 imSize(2)];
  X2 = [displayStruct.iNumber(3) displayStruct.iNumber(3)];
  Y1 = [displayStruct.iNumber(2) displayStruct.iNumber(2)];
  Y2 = [1 imSize(1)];
 case 2,
  ori = 'Axial';
  X1 = [displayStruct.iNumber(1) displayStruct.iNumber(1)];
  X2 = [1 imSize(1)];
  Y1 = [1 imSize(2)];
  Y2 = [displayStruct.iNumber(3) displayStruct.iNumber(3)];
 case 3,
  ori = 'Coronal';
  X1 = [1 imSize(1)];
  X2 = [displayStruct.iNumber(1) displayStruct.iNumber(1)];
  Y1 = [displayStruct.iNumber(2) displayStruct.iNumber(2)];
  Y2 = [1 imSize(2)];
 otherwise,
  errordlg('Invalid slice orientation.')
end

plot(X1,Y1,'g:',X2,Y2,'g:');
hold off

switch displayStruct.activeSliceOri
case 1
    set(gca,'DataAspectRatio',[240/256,240/256,1.2]);
 otherwise
    set(gca,'DataAspectRatio',[240/256,1.2,240/256]);
end

% Set the title
if (min(size(vData)) == 1)
  % Routine passed one image in dummy structure
  str = sprintf('%s Image %3d ',...
      ori,displayStruct.iNumber(displayStruct.activeSliceOri));
else
    str = sprintf('%s Image %3d out of %3d',...
	ori,displayStruct.iNumber(displayStruct.activeSliceOri),vSize(displayStruct.activeSliceOri,3));
end

title(str);

if ~axisflag
  axis off
end




