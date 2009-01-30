function [pWindow]=mrEditPwindow(pWindow);
%[pWindow]=mrEditPwindow(pWindow);
% 	allows user to edit variable pWindow
temp  =   input('Phase window (i.e. [0,360]): ');
if (size(temp)==[1,2]) 
	pWindow=temp;
else
	disp('*** err: Invalid Input Size');
end

% Adjust pWindow for principal angle

scfac=180/pi;
pWindow=angle(exp(sqrt(-1)*(pWindow-180)/scfac))*scfac+180;

