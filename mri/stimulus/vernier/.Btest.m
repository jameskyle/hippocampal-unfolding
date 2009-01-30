%AUTHORS: Dennis and Brian
%DATE:  06.18.97
%
%PURPOSE:
%  Develop an example of a vernier displacement experiment.  The
%goal at the moment is to make two sets of stimuli.  In one case
%the subject is asked to make a vernier discrimination between
%the test/central strip and the flanks.  In the other case the
%subject is asked to make a contrast discrimination
% 
%

% Define the basic stimulus dimensions
%
nx = 128; ny = 128; nGray = 128;
mp = gray(nGray);


% Make the fixed part of the stimulus
%
flankFreq = 10;
flankWidth = 20;
centerWidth = flankWidth;

y = 1:ny;
flanksLeft = sin(2*pi*flankFreq*y/ny);
plot(flanksLeft)

% Widen it up by multiplying flanksLeft as a column times a
% vector that is 1 row and flankWidth wide.
% 
flanksLeft = flanksLeft'*ones(1,flankWidth);
flanksRight = flanksLeft;

% Take a look at it.
% 
% colormap(mp);imagesc(flanksLeft); axis image

% Create space for the background image that will be fixed
% throughout the experiment.  What will change is the central
% region. 
backImage = zeros(nx,ny);

middleImage = nx/2;
leftStart = middleImage - 3/2*flankWidth;
rightStart = middleImage + 1/2*flankWidth;
backImage(1:ny,leftStart:(leftStart+flankWidth-1)) = flanksLeft;
backImage(1:ny,rightStart:(rightStart+flankWidth-1)) = flanksRight;

% 
% colormap(mp);imagesc(backImage); axis image

% Next, make a central strip that will be either displaced or
% whose contrast will be varied.
% 
colormap(mp);
for displacement = [0:.1:10]
  centerImage = sin(2*pi*flankFreq*(y+displacement)/ny);
  centerStart = middleImage - 0.5*flankWidth;
  centerImage = centerImage'*ones(1,flankWidth);

  testImage = zeros(size(backImage));
  testImage(1:ny,centerStart:(centerStart+flankWidth-1)) = centerImage;

  % Check the test image
  % 
  stimulus = scale(backImage + testImage,1,nGray);
  image(stimulus),axis image, pause(0.1)
  fprintf('Next stim %f\n',displacement)
end

