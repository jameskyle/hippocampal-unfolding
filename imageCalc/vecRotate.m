function res = vecRotate(v,shift,direction)
%
%AUTHOR:  Wandell
%DATE:    July 21, 1994
%PURPOSE:
%
%   res = vecRotate(v,shift)
%   res = vecRotate(v,shift,direction)
%
%  The input vector, v, is circularly shifted by the amount, shift.
%  By default the shift is leftward, so that
%  if 
%     v = [1 2 3 4 5] and shift = 2,
%  then returned result is 
%     [3 4 5 1 2].
%  
%  If direction = 'r' or 'R', then the vector is rotated to the right.
%
%  In general, shift may be any number.  This routine uses
%
%    shift = shift(mod,length(v)) 
%
%  as the size of the shift.
%
% 03.12.97 ABP -- Fixed for direction 'r'.
% N.B.  The value of shift is rounded to the nearest integer, and no
%	warning is issued if round(shift) = 0.
%
shift = round(shift);
if shift == 0
%  disp('vecRotate: The requested shift is rounded to 0')
end

if (nargin == 3)
  if (direction(1) == 'r' | direction(1) == 'R')
    shift = -shift;
  end
end

% If the input is a column vector, left and right get translated
% into up and down.
% 
if size(v,2) == 1
  v = v';
  colVector = 't';
else
  colVector = 'f';
end
  
nv = length(v);
if shift == 0
  res = v;
  return;
else
 shift = mod(shift,nv);
end
    
% 03.12.97 ABP -- Fails when requesting a right shift.
% Fix by changing the shift amount
% appropriately and always shifting left.  This looks like
% be the easiest way.
if (shift < 0)
  shift = nv + shift;
end
%
%	Main code
%
res = zeros(size(v));
res(1:nv-shift) = v(shift+1:nv);
res(length(v) - shift + 1:nv) = v(1:shift);

if colVector == 't'
  res = reshape(res,length(res),1);
end
 
return;
