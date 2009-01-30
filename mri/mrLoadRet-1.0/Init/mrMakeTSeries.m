function  mrMakeTSeries(numofexps, imagesperexp, size, crop,compressAsUGo)

% mrMakeTSeries (numofexps, imagesperexp, size, crop,[compressAsUGo])
%
%	Reads the functional data, experiment by experiment, by calling mrSeries.
% It saves the raw (clipped) data in files called "tSeries'n'" where 'n' is the
% number of the experiment. 
%
%   size is the raw image size (usually [256,256]).

% 3/10/96  gmb	Now uncompresses image files and compresses them again (if necessary)
% 4/2/96   gmb  compresses image files after calculating tSeries if compressAsUGo(1)=='y'

% Variable declarations
i = 1;       	% a counter
tSeries = [];   % a matrix in which each column is a pixel and each row is
		% a sample in time.
estr = '';	% Hack to avoid MatLab's stupid convention of not eval'ing variable names

if (nargin<5)
	compressAsUGo='n';
end

global dr;

for i=1:numofexps
	%check if files are compressed
	if exist([dr,'/exp',int2str(i),'/I.001.gz'])
		disp(['Uncompressing exp',int2str(i)]);
		uncompress=1;		
		str=['gunzip -r ',dr,'/exp',int2str(i)];
		unix(str);
	else
		uncompress=0;
	end
	tSeries = mrSeries( [dr,'/exp' int2str(i)], [1:imagesperexp], size, crop, 0 );
	estr = ['save tSeries',num2str(i), ' tSeries'];
	eval(estr);

	%compress files again if they started out that way.
	if uncompress==1 | compressAsUGo(1)=='y'
		disp(['Compressing exp',int2str(i)]);
		str=['gzip -r ',dr,'/exp',int2str(i)];
		unix(str);
	end
end







