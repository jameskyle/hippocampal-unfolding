function [inplane_pix_size] = mrGetIPPixSize()
%function [inplane_pix_size] = mrGetIPPixSize()
%
% PURPOSE: Prompt the user for the inplane anatomy pixel size
% AUTHOR:  Poirson 
% DATE:    07.16.97
% HISTORY: Based on routine by Geoff Boynton 
% NOTES:   The default values [256/260,256/260,1/4] mean that
%          26 cm of brain image are interpolated on the 256 pixels
%          in the x and y dimensions (units are pixels/mm).
%          And that 1 pixel in the inplane direction equals 4mm thickness.
%

qt=''''; %single quote character

disp('Enter size of inplane anatomy pixels/mm in x,y and z directions');
inplane_pix_size=input('Default is [256/260,256/260,1/4]: ');

%Or go the default
if inplane_pix_size==[]
	inplane_pix_size=[256/260,256/260,1/4];
end

return




