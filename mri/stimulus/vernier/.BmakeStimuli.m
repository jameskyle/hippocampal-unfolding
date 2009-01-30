% script
% 
%AUTHORS: Dennis and Brian
%DATE:  06.18.97
%
%PURPOSE: Create a stimulus for the vernier displacement vs.
% contrast variation amblyopia experiment.  The goal at the moment is
% to make two sets of stimuli.  In this case the subject is asked
% to make either (a) a vernier discrimination between a set of test strips
% that are moving (slightly) up and down relative a fixed set of
% strips, or (b) a contrast discrimination between these test
% strips and the fixed strips. 

% 
% The parallel experiment will display a contrast varying form of
% these stimuli.

% Define the basic stimulus dimensions
%
workDir = '/home/brian/exp/mri/vernier';
% changeDir(workDir);

codeDir = '/home/brian/matlab/toolbox/mri/stimulus/vernier';
% changeDir(codeDir);

% General image size parameters
% 
nRow = 200; nCol = 200; nGray = 128;
y = 1:nCol; x = 1:nRow;
mp = gray(nGray);
backImage = zeros(nRow,nCol);

% Open up a window of just the right size
% 
figNum = figure;
rect = get(figNum,'Position');
set(figNum, 'Position', [rect(1), rect(2), nCol, nRow]);
ha = gca; set(ha, 'Units', 'pixels');
axis off; set(ha, 'Position', [1, 1, nCol, nRow]);

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
nSteps = 50;
displacement = pi*sin(2*pi*[0:(nSteps)]/nSteps);

% Create the fixed Pattern
fixedPattern = sin(2*pi*variableFreq*(y/nCol) + displacement(1));
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
imageCenter = nRow/2;
patternWidth = (variableWidth + fixedWidth)
leftStart = imageCenter - ...
    ( (fixedWidth + 0.5*variableWidth) + ...
    (nFixed/2-1)*(patternWidth));

for ii=1:nFixed
  curStart = leftStart + (ii - 1)*patternWidth;
  backImage(1:nCol,curStart:(curStart + fixedWidth-1)) = fixedPattern;
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
dStimulus = zeros(nRow*nCol,nFrames);
for ii=1:nFrames
  variableImage = zeros(nRow,nCol);
  variablePattern = ...
      sin(2*pi*variableFreq*(y/nCol) + displacement(ii));
  variablePattern = variablePattern'*ones(1,variableWidth);

  for jj=1:nVariable
    curStart = leftStart + (jj-1)*patternWidth;
    variableImage(1:nCol, curStart:(curStart+variableWidth-1)) = variablePattern;
  end
  tmp = scale(backImage + variableImage,1,nGray);
  dStimulus(:,ii) = tmp(:);
  image(tmp), axis image
  M(:,ii) = getframe;  pause(0.5)
  fprintf('Displacement %f\n',displacement(ii))
end
movie(M,5)

% Make the contrast varying form of this stimulus
% 
nSteps = 50;
contrast = cos(2*pi*[0:(nSteps)]/nSteps);
cStimulus = zeros(nRow*nCol,nFrames);

nFrames = length(contrast);
for ii=1:nFrames
  variableImage = zeros(nRow,nCol);
  variablePattern = ...
      contrast(ii)*sin(2*pi*variableFreq*(y/nCol));
  variablePattern = variablePattern'*ones(1,variableWidth);

  for jj=1:nVariable
    curStart = leftStart + (jj-1)*patternWidth;
    variableImage(1:nCol, curStart:(curStart+variableWidth-1)) = ...
	variablePattern;
  end

  tmp = scale(backImage + variableImage,1,nGray);
  cStimulus(:,ii) = tmp(:);
  image(tmp), axis image
  M(:,ii) = getframe; pause(0.5)
  fprintf('Contrast %f\n',contrast(ii))
end

% For storing out.
% 
parameters.nRow = nRow;
parameters.nCol = nCol;
parameters.nGray = nGray;
parameters.fixedF = fixedFreq;
parameters.fixedW = fixedWidth;
parameters.varF = variableFreq;
parameters.varW = variableWidth;
parameters.nSteps = nSteps;

comment = sprintf('dStimulus:  displacing stimulus\n')
comment = [comment, sprintf('cStimulus: contrast varying stimulus\n')]
parameters.comment = comment

changeDir(workDir)
save stimulus dStimulus cStimulus parameters

return;

% If you want to see this as a movie, run this code
% 
stim = dStimulus;
stim = cStimulus;
M = moviein(nFrames);
for ii=1:size(stim,2)
  image(reshape(stimulus(:,ii),nRow,nCol));
  axis image
  M(:,ii) = getframe;
end
movie(M,5)