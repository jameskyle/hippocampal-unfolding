% mrShowImage.m
% -------------
%
% function imHandle = mrShowImage(in, imSize, scaleImage, cmap)
%
%
%  AUTHOR: Brian Wandell
%    DATE: (unknown)
%
% PURPOSE:
%          Displays an image (coded as a vector).
%          Note that the axis type is always set to image.
%
% ARGUMENTS:
%  	     in: Input image data in vector form.
%        imSize: Input image size.
%    scaleImage: If 's', use imagesc, otherwise use image.
%          cmap: If this argument is sent, use it to set the color map.
%
% RETURNS:
%      imHandle: The handle to the displayed image.
%
%

function imHandle = mrShowImage(in, imSize, scaleImage, cmap)


%% Go ahead and display the image. The code is self-expanatory!
%
 if nargin == 3 | nargin == 4
   if scaleImage == 's'
     imHandle = imagesc(reshape(in,imSize(1),imSize(2)));
   else
     imHandle = image(reshape(in,imSize(1),imSize(2)));
   end
   if nargin == 4
     colormap(cmap);
   end

 elseif nargin == 2

   imHandle = image(reshape(in,imSize(1),imSize(2)));

 elseif nargin < 2

   error('mrShowImage: Too few arguments.')

 end


%% Set the axis to image.
%
 axis image


%%%%