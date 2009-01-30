%fMRIMovieDemo.m
%5/22/98 gmb  Wrote it.
%
%Generates and shows a movie from Heidi Basseler's brain
%from a rotating wedge retinotopy scan.
%
%Parameter settings:
%
homedr = pwd;
datadr = '/usr/local/mri/retinotopy/baseler/030598';
nFrames = 64;  %frames per cycle
gamma = 0.5;   %gamma for scaling greyscale values of anatomy image
ampFac = 30;   %amplitude scale factor.  
nBlurs = 1;    %number of spatial blurs with [1,4,6,4,1] square
%              filter on data in the complex plane.
cothresh = 0.5;  
sliceNum = 2;  %slice used for animation.
refScanNum = 6;   %reference scan number
scanNum = 6;   %scan number (can be a vector for averaging across scans) 
                   %(1 for MT ref, 2 for checkerboard)

makefMRIMovie
M=showMovie(fMRIMovie,cmap,10);
