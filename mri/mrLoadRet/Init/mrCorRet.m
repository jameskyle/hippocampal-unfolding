function [co, ph, amp, dc] = mrCorRet (numofexps, imagesperexp, period,junkimages,ltrend)

% [co,ph,amp,dc]=mrCorRet (numofexps, imagesperexp, period, junkimages,[ltrend]);
%
%	Reads the functional data, experiment by experiment, by calling mrSeries.
% It saves the raw (clipped) data in files called "tSeries'n'" where 'n' is the
% number of the experiment.  Once each series of functional data has been loaded,
% clipped, and saved, the data are correlated with the appropriate sinusoids
% (mrAdCorRet).  The results of the anaylsis are placed in three matrices, co, ph, and
% amp.  These matrices are returned by the function in the aforementioned order.
% In each matrix, each row corresponds to an  experiment and each column is a pixel.
% If ltrend(1)=='y' the linear trend is subtracted, if ltrend is not given, a
% prompt asks for it.
% 
% HAB, 7/21/97:  Added "clear tSeries" to free up workspace and reduce memory 
% shortage problems.  Also removed declaration of variables which were unused.

% 8/6/97  djh  modified to return the dc
%%% 062000 csf modified to allow junkimages at both begining and end

if (~exist('ltrend'))
	ltrend=input('Subtract linear trend? ','s');
end

% Variable declarations
tSeries = [];   % a matrix in which each column is a pixel and each row is
		% a sample in time.

global dr;

for i=1:numofexps
  disp(['experiment ',num2str(i)]);
  eval(['load tSeries',num2str(i)]);
  if length(junkimages)==1
    dat = tSeries(junkimages+1:imagesperexp,:);
  elseif length(junkimages)==2
    dat = tSeries(junkimages(1)+1:imagesperexp-junkimages(2),:);
    disp(['mrCorRet: cutting images from both ends']);
  end
  clear tSeries
  [co(i,:),ph(i,:),amp(i,:),dc(i,:)]=mrFTCorSeries(dat,period,ltrend);
  % [co(i,:), ph(i,:), seph(i,:)] = mrAdCorSeries (tSeries,periods);
  % [amp(i,:), stdamp(i,:)] = mrConRespRet (tSeries, periods);
end







