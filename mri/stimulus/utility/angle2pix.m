function n=angle2pix(a,dist,w)
%ANGLE2PIX
%n=angle2pix(a,dist,w)
%
%returns width of square in pixels for visual angle a
% 'dist' is distance from monitor 
% 'w' is pixel width (cm) of projector/monitor
%
%examples:
%	angle2pix(10,21.5,0.0825)
%		number of pixels for GE Signa (close screen)
%
%	angle2pix(10,127.5,0.075)
%		number of pixels for GE Signa (new semicircular 
%               screen midway in bore)
%
%	angle2pix(10,170,0.0667)
%		number of pixels for GE Signa (old rectangular 
%               screen outside bore)
%
%	angle2pix(10,[50],[0.03])
%		number of pixels for psychophysics

% Commented out this line for use on UNIX machines - HB, 5/6/97
% psychoglobals

if nargin<2
	dist=gDist;
end

if nargin<3
	w=gPwidth;
end

n=2*dist*tan(a*pi/360)/w;
