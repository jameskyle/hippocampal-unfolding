function m = meanPhase(ph)
%
%         m =  meanPhase(ph)
%
%AUTHOR: Engel, Wandell
%DATE:   Unknown
%
%PURPOSE: 
%  Compute the mean phase value in a region taking into account
%  the possibility that the phase values may wrap around 2 pi.
%
%	ph:  Vector of phase values (in radians)
%	m:   Mean phase of the vector
%	

s = mean(sin(ph));
c = mean(cos(ph));
m = atan2(s,c);

