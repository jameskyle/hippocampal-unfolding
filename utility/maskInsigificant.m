function res = maskInsignificant(im,sig,maskValue)
%
%   function res = maskInsignificant(im,sig,maskValue)
%
%AUTHOR:  Wandell
%DATE:  April 23, 1995
%PURPOSE:
%  Replace all of the insignificant locations in a vector
%  with a new value.
%
%	im:  Input vector
%
%	sig:  Significant locations
%		This is an vector with length to im, and 1s at the
%		significant locations, 0s otherwise.
%
%	maskValue:  The value to be entered at the insignificant locations
%		If this argument is not passed, the default is 1.
%		 (first entry of the color map).

if nargin == 2
  newValue = 1;
  disp('Replacing insigificant values with 1')
end

res = im;
nMasked = sum(~sig);
res(~sig) = maskValue*ones(1,nMasked);
