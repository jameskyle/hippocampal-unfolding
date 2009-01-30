%
%	The matrices here are from Pratt Digital Image Processing, 2nd ed.
%	page 67.  They probably should be taken from a more reliable/accurate
%	and reputable source.
%
%	Gigi and Brian 3/3/95
%
load XYZ

XYZ2YIQ = [0.0 1 0.0; 1.407 -.842 -.451; 0.932 -1.189 0.233];
YIQ2XYZ = [.967 .318 .594; 1 0 0; 1.173 -1.238 1.870]

YIQ = XYZ2YIQ*XYZ';
YIQ = YIQ';

save YIQ XYZ2YIQ YIQ2XYZ YIQ 

