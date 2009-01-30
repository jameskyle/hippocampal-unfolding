% scale.m
% -------
%
% function sim = scale(im, newMin, newMax, oldMin, oldMax);
%
%  AUTHOR: Rick Anthony
%    DATE: 6/23/93
% PURPOSE:
%	 Scales an image such that its lowest value attains newMin and
%	 its highest value attains newMax. OldMin and oldMax are not
%	 necessary but are useful when you don't want to use the true
%	 min or max value.  
%
% ARGUMENTS:
%            im: The image to be scaled.
%        newMin: New desired minimum image value.
%        newMax: New desired maximum image value.
%        oldMin: Old minimum value of the image.
%        oldMax: Old maximim value of the image.
%
% RETURNS:
%        sim: The scaled image with a value range between the specified
%             newMin and newMax.
%
%

function sim = scale(im, newMin, newMax, oldMin, oldMax)


%%  Find oldMin and oldMax if they aren't specified.	
 if (nargin < 4) oldMin = min(min(im)); end
 if (nargin < 5) oldMax = max(max(im)); end

%% Find delta, the ratio between new variation to old variation.
 delta = (newMax-newMin)/(oldMax-oldMin);

%% Scale the image so that the value variations are between newMin 
%% and newMax.
%
 sim = delta*(im-oldMin) + newMin;


%%%%