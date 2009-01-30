function [xyLines, lhandle] = overlayBox(boxCoords,clr,lstyle)
%
%AUTHOR:  Wandell
%FUNCTION:
%
% function [xyLines lhandle] = overlayBox(boxCoords,clr,lstyle)
%
%  boxCoords:  4 coordinates defining the box
%  clr:        the rgb values of the line (optional)
%  lstyle:     line style (e.g. '..')  (optional)
%  
%  Overlay a box on an image at the locations in boxCoords.
%  The box coordinates are in [X,Y] format.
%  The ulx,uly are in the first row and lrx,lry are in the second row.
%
%  xyLines:  the actual coordinates of the lines in
%  lhandle:  a handle to the lines so they may be deleted.
%
%SEE ALSO:  imCrop, mrCrop
%

ulx = boxCoords(1,1); uly = boxCoords(1,2);
lrx = boxCoords(2,1); lry = boxCoords(2,2);

a = [ulx lrx lrx lrx lrx ulx ulx ulx];
b = [uly uly uly lry lry lry lry uly];
lhandle = line(a,b);

if nargin == 2		%User sets color

 set(lhandle,'Color',clr);

elseif nargin == 3		%User sets linestyle

 set(lhandle,'Linestyle',lstyle);

end

xyLines = [a;b];


