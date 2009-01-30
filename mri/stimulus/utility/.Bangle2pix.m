function n=angle2pix(a,dist,w)
%ANGLE2PIX
%n=angle2pix(a,dist,w)
%
%returns width of square in pixels for visual angle a
% 'dist' is distance from monitor 
% 'w' is pixel width (cm) of projector/monitor
%
% examples:
%	pix2angle(100,21.5,0.0825)
%		visual angle for GE Signa (close screen)
%
%	pix2angle(100,127.5,0.0664)
%		visual angle for GE Signa (screen outside bore)
%
%	pix2angle(100,[50],[0.03])
%		visual angle for psychophysics


%psychoglobals

%if nargin<2
	dist=gDist;
%end

%if nargin<3
%	w=gPwidth;
%end

n=2*dist*tan(a*pi/360)/w;
