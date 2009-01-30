%function InsertBitImage(img,bitMovie,frameNumber)
%
%   InsertBitImage(img,bitMovie,frameNumber)
%
%AUTHOR:  Boynton
%DATE:  02.20.95
%PURPOSE:
% 	Write an image into the movie frame of a bitMovie.
%
%	img:  an m x n image frame.  The values are assumed to
%	 	be scaled between 0 and 1, and the routine
%		scales them to be between 0 and 255.
%	bitMovie:  A bit movie initialized by zerobitimage
%
%	After creating the bitMovie, you must still convert the data
%	on the Mac using a matlab script (see Boynton) that is called
%			convertsun2mac.m
