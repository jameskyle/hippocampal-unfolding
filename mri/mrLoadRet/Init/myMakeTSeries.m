% myMakeTSeries (numofexps, imagesperexp, size, crop, header)
%
%	Reads the functional data, experiment by experiment, by calling mrSeries.
% It saves the raw (clipped) data in files called "tSeries'n'" where 'n' is the
% number of the experiment. 
%
%   size is the raw image size (usually [256,256]).

function  myMakeTSeries(numofexps, imagesperexp, size, crop, header)

% Variable declarations
i = 1;       	% a counter
tSeries = [];   % a matrix in which each column is a pixel and each row is
		% a sample in time.
estr = '';	% Hack to avoid MatLab's stupid convention of not eval'ing variable names

global dr;

for i=1:numofexps
	tSeries = mrSeries( [dr,'/exp' int2str(i)], [1:imagesperexp], size, crop, header );
	estr = ['save tSeries',num2str(i), ' tSeries'];
	eval(estr);
end




