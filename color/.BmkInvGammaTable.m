function result = mkInvGammaTable(gTable,numEntries)
%
%AUTHOR: Xuemei Zhang and B. Wandell
%DATE:   04.10.96
%
%PURPOSE:
%
%  Find the inverse of a gamma table that maps the frame-buffer entries
%  used to control a monitor into linear intensity.
%
%  The table must be monotonic (or else the inverse doesn't exist).
%  In some cases, noise leads to non-monotonicities.  On this
%  assumption, we sort non-monotonic tables and warn the user.
%
%  gTable:      Gamma table from frame-buffer to linear intensity
%  numEntries:  Number of sample values in the inverse table
%  result:      Inverse gamma table that maps from linear intensity to
%	           frame-buffer value.
%
%
% TEST CODE AT END

ncol = size(gTable,2);
result = zeros(numEntries,ncol);

%  Check for monotonicity, and fix if not monotone
%
for i=1:ncol

 thisTable = gTable(:,i);

% Find the locations where this table is not monotonic
%
 list = find(diff(thisTable) <= 0);

 if length(list) > 0
  announce = sprintf('Gamma table %d NOT MONOTONIC.  We are adjusting.',i);
  disp(announce)

% We assume that the non-monotonic points only differ due to noise
% and so we can resort them without any consequences
%
  thisTable = sort(thisTable);

% Find the sorted locations that are actually increasing.
% In a sequence of [ 1 1 2 ] the diff operation returns the location 2
%
  posLocs = find(diff(thisTable) > 0);

% We now shift these up and add in the first location
%
  posLocs = [1; (posLocs + 1)];
  monTable = thisTable(posLocs,:);

 else

% If we were monotonic, then yea!
  monTable = thisTable;
  posLocs = 1:size(thisTable,1);
 end

 nrow = size(monTable,1);

% Interpolate the monotone table out to the proper size
%
 result(:,i) = ...
   interp1(monTable,posLocs-1,[0:(numEntries-1)]/(numEntries-1)); 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test code
% load displayGamma
%
% Go through the cycle once to get rgb values
% that are on the interpolation grid
%
% rgb = rand(3,3)
% dac = rgb2dac(rgb,invGamma)
% rgb2 = dac2rgb(dac,gamma)
%
%  Now, rgb2dac and dac2rgb should be inverses
%
% dac2 = rgb2dac(rgb2,invGamma)
% rgb3 = dac2rgb(dac2,gamma)
% rgb3 - rgb2
