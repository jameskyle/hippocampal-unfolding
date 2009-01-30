function side= mrExistSides(dr)
%side= mrExistSides([dr])
%
%Determines which hemispheres (sides) are analyzed by
%Finding the following files in directory 'dr'
%
%(FCorAnal_left.mat  and Fanat_left.mat)  or
%(FCorAnal_right.mat and FCorAnal_left.mat)
%
%inputs:   dr is the current directory by default.
%returns:  side = '' , 'l' , 'r' , or 'lr'

%9/9/96 gmb  Wrote it.

if nargin ==0
  dr = pwd;
end

side = '';
if check4File([dr,'/FCorAnal_left'])  & ...
   check4File([dr,'/Fanat_left'])
	side = [side,'l'];
end

if check4File([dr,'/FCorAnal_right']) & ...
   check4File([dr,'/Fanat_right'])
	side = [side,'r'];
end

