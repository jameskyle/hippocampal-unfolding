function sim = ScaleImage(im, newMin, newMax, oldMin, oldMax);
%
%  ScaleImage(Image, newMin, newMax, oldMin, oldMax)
%	Scales an image such that its lowest value attains newMin and
%	its highest value attains newMax.  OldMin and oldMax are not
%	necessary but are useful when trying to scale images that only
%	contain one value.  
%
%  Note: the scaled values are not rounded.  
%
%  Rick Anthony
%  6/23/93

%  find oldMin and oldMax if they aren't specified.	
if nargin ~= 5
    oldMax = max(max(im));
    oldMin = min(min(im));
end

delta = (newMax-newMin)/(oldMax-oldMin);
sim = delta*(im-oldMin) + newMin;


