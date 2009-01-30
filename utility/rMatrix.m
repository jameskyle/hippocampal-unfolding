function M = rMatrix(rad)
%
%AUTHOR:  Wandell
%DATE:    12.8.94
%PURPOSE:
%  Compute the two or three dimensional rotation matrix corresponding
%  to the argument in rad.  
%   rad: represents the rotation measured in radians.  
%   M:   is the rotation matrix, organized so that the rotation is
%
%          M(rad) v 
%
%  If rad is a scalar, then the two-dimensional rotation matrix is
%  returned. 
%
%  If rad is a three-vector, then the three-dimensional rotation matrix is
%  returned.  Each of the entries of rad describes
%  a rotation around the X, Y, and Z axes.
%  These rotations are performed in order: X, then Y, then Z.
%

%	The rotation matrices computed here are copioed (in transposed form)
%  from Foley and van Dam p. 257.
%

if length(rad) == 1

 M = [cos(rad) -sin(rad) ; sin(rad) cos(rad) ];
 return;

elseif length(rad) == 3

 rx = [1      0            0; 
       0 cos(rad(1)) -sin(rad(1)); 
       0 sin(rad(1)) cos(rad(1))];

 ry = [ cos(rad(2))  0 sin(rad(2)); 
        0            1   0; 
       -sin(rad(2))  0 cos(rad(2)) ];

 rz = [cos(rad(3)) -sin(rad(3)) 0 ; 
       sin(rad(3)) cos(rad(3))  0 ;  
          0            0        1]; 

 M = rz*ry*rx; 
 return;

else

 error('rMatrix:  rad must be a scalar or 3-d vector.')

end
