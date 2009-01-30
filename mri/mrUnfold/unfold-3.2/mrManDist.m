% mrManDist.m
% --------------------
%
% function [dist, nPntsReached] = mrManDist(grayNodes, grayEdges,
%                                           startPt, :dimdist, :noVol, :radius)
%
%  AUTHOR:  S. Engel, B. Wandell
%    DATE:  May, 1995
% PURPOSE:
%         Computes the distances within the gray matter manifold between 
%         the start point and other gray matter points. 
%         (This only exists as a mex4 file at present).
%
% ARGUMENTS:
%   grayNodes, grayEdges : gray matter graph.
%       startPt: grayNode index where to start the flood fill.
%
%    (Optional)
%       dimdist: N.B.: Array of y, x and z separations between points. 
%         noVol: The value returned for unreached locations (default 0).
%       nRadius: The max distance to flood out.
%                (default 0 == flood as far as can)
%
% RETURNS:
%          dist: Vector of distances to each point from startPt. 
%                (Length = number of elements in grayM)
%  nPntsReached: The number of points reached from startPt.  To check
%                continuity each gray matter point should have been reached.
%
 
%%%%
