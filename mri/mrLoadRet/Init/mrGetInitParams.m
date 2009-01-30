%Lets the user input the following parameters:
%	numofexps
%	imagesperexp
%	dr
%
%and stores them under the filename ExpParams in the current directory.
%9/27/94 	gmb	wrote it.
%12/12/95	gmb	changed to querry 'number of scans' instead of 'experiments'


temp = input('Number of anatomy inplanes: ');
if (size(temp))
	numofanats = temp;
end

temp  =   input('Number of experiments (P files): ');
% 6/30/97 Lea updated to 5.0
if (size(temp)) 
	nscans=temp;
else 
        nscans=0;
end

numofexps=nscans*numofanats;

temp = input('Number of temporal frames (functional images per plane): ');
if (size(temp))
	imagesperexp = temp;
end

temp = input('Number of temporal cycles per experiment: ');
if (size(temp))
	ncycles = temp;
end

temp = input('Discard the first (n) temporal frames: n=');
if (size(temp))
	junkimages = temp;
end

dr='';

disp('');
disp(['Directory of anatomy images is ',pwd]);

dr = input('Press <return> to accept, or enter a new directory: ','s');

if (~size(dr)) 
	dr = pwd;
end

str='save ExpParams numofexps imagesperexp numofanats dr ncycles junkimages';
eval(str);































