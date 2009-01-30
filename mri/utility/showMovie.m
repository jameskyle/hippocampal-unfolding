function M=showMovie(movieImages,cmap,nCycles)
%M=showMovie(movieImages,[cmap],[nCycles])
%Generates and shows a matlab movie
% Inputs:
%    movieImages  An [m,n,nFrames] sized matrix holding an image sequence 
%    cmap         Single color map used for image sequence (default is gray)
%    nCycles      Number of times the movie is repeated (Default is 10)
% Outputs:
%    M            Matlab movie matrix.  The movie is shown  with the command 
%                 "movie(M,nCycles)"
%See also MOVIE, GETFRAME, MOVIEIN.

%4/22/98 gmb  Wrote it.

if ~exist('cmap')
  cmap = gray;
end

if ~exist('nCycles')
  nCycles = 10;
end

nFrames = size(movieImages,3);

close all
figure('MenuBar','none','NumberTitle','off')
axis equal
backImage = ones(size(movieImages,1),size(movieImages,2));
h = image(backImage);
set(gca,'Position',[0,0,1,1]);
axis off
colormap(cmap)

M = moviein(nFrames);

disp('Storing movie...');
for frameNum=1:nFrames
  set(h,'CData',movieImages(:,:,frameNum));
  M(:,frameNum) = getframe;
end

if nCycles>0
  disp('Showing movie...');
  movie(M,nCycles)
end
