function a=pix2angle(n,dist,w)
%PIX2ANGLE
%a=pix2angle(n,[dist],[w])
%
%returns visual angle of nxn square.
%
% 'dist' is distance from monitor 
% 'w' is pixel width (cm) of projector/monitor
%
%examples:
%	pix2angle(100,21.5,0.0825)
%		visual angle for GE Signa (close screen)
%
%	pix2angle(100,127.5,0.075)
%		visual angle for GE Signa (new semicircular 
%               screen midway in bore)
%
%	pix2angle(100,170,0.0667)
%		visual angle for GE Signa (old rectangular 
%               screen outside bore)
%
%	pix2angle(100,[50],[0.03])
%		visual angle for psychophysics

% Commented out this line for use on UNIX machines - HB, 5/6/97
% psychoglobals

if nargin<2
	dist=gDist;
end

if nargin<3
	w=gPwidth;
end

a=2*180*atan(w*(n/2)/dist)/pi;

