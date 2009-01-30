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
workDir = '/home/brian/exp/mri/vernier';
% changeDir(workDir);
codeDir = '/home/brian/matlab/toolbox/mri/stimulus/vernier';
% changeDir(codeDir);

% General image size parameters
% 
nx = 200; ny = 200; nGray = 128;
y = 1:ny; x = 1:nx;
mp = gray(nGray);
backImage = zeros(nx,ny);

% Open up a window of just the right size
% 
figNum = figure;
rect = get(figNum,'Position');
set(figNum, 'Position', [rect(1), rect(2), ny, nx]);
ha = gca; set(ha, 'Units', 'pixels');
axis off; set(ha, 'Position', [1, 1, ny, nx]);

% Parameters of the fixed and varying patterns in the
% display. 
%
% The number of fixed patterns must be an even number
% 
nFixed = 4;
if (2*round(nFixed/2) ~= nFixed)
  error('nFixed must be an even number')
end
nVariable = nFixed - 1;

fixedFreq = 10; variableFreq = fixedFreq;
fixedWidth = 20; variableWidth = 10;
% displacement = [0:.1:1]*pi;
nDelta = 20;
displacement = sin(2*pi*[0:.05:1])

% Create the fixed Pattern

% fixedPattern = sin(2*pi*fixedFreq*y/ny);
fixedPattern = sin(2*pi*variableFreq*(y/ny) + displacement(1));
% plot(fixedPattern)

% Widen it up by multiplying fixedsLeft as a column times a
% vector that is 1 row and fixedWidth wide.
% 
fixedPattern = fixedPattern'*ones(1,fixedWidth);

% Take a look at it.
% 
% colormap(mp);imagesc(fixedPattern); axis image

% Insert the fixed patterns into their positions in the
% background. 
% 
imageCenter = nx/2;
patternWidth = (variableWidth + fixedWidth)
leftStart = imageCenter - ...
    ( (fixedWidth + 0.5*variableWidth) + ...
    (nFixed/2-1)*(patternWidth));

for ii=1:nFixed
  curStart = leftStart + (ii - 1)*patternWidth;
  backImage(1:ny,curStart:(curStart + fixedWidth-1)) = fixedPattern;
end

% 
% colormap(mp);imagesc(backImage); axis image

% Next, make a central strip that will be either displaced or
% whose contrast will be varied.
% 
colormap(mp);
leftStart = imageCenter - (0.5*variableWidth + (nVariable-1)/2*(patternWidth));

% This tells us what fraction of the stimulus period we are
% displacing the variable pattern
% 
nFrames = length(displacement);
M = moviein(nFrames);
for ii=1:nFrames
  variableImage = zeros(nx,ny);
  variablePattern = ...
      sin(2*pi*variableFreq*(y/ny) + displacement(ii));
  variablePattern = variablePattern'*ones(1,variableWidth);

  for jj=1:nVariable
    curStart = leftStart + (jj-1)*patternWidth;
    variableImage(1:ny, curStart:(curStart+variableWidth-1)) = variablePattern;
  end

  stimulus = scale(backImage + variableImage,1,nGray);
  image(stimulus)
  axis image
  M(:,ii) = getframe;
  pause(0.5)
  fprintf('Displacement %f\n',displacement(ii))
end

% movie(M)
