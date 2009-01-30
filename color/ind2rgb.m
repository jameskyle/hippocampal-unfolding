function [r,g,b] = ind2rgb(a,cm)
%IND2RGB Convert indexed image to an RGB image.
%	[R,G,B] = IND2RGB(X,MAP) separates the indexed image X with 
%	colormap MAP into R, G, B components.  The matrices R, G, B
%	contain intensities of the red, green, and blue components
%	of the image A.  The intensity 0 is black, while the 
%	intensity 1 corresponds to full saturation of the color.
%
%	See also: RGB2IND, IND2GRAY.

%	Clay M. Thompson 9-29-92
%	Copyright (c) 1992 by The MathWorks, Inc.
%	$Revision: 1.8 $  $Date: 1993/09/07 19:51:13 $

error(nargchk(2,2,nargin));

% Make sure A is in the range from 1 to size(cm,1)
a = max(1,min(a,size(cm,1)));

% Extract r,g,b components
r = zeros(size(a)); r(:) = cm(a,1);
g = zeros(size(a)); g(:) = cm(a,2);
b = zeros(size(a)); b(:) = cm(a,3);
