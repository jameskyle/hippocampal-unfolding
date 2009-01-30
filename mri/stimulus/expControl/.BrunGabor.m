% runGabor
% Script to run color Gabor stimuli - 2 different color
% directions (L-M and L+M) and 6 different spatial frequencies
% Baseler and Wandell, 11/4/96

%clear all

globals
global gCountDown gBkcolor
gCountDown=5;

% On the Sanyo this is always the frame rate, though it is different
% when we test in the lab, sigh.
% NOTE:  Using an image 457x457 in size reduces the effective frame
% rate by a factor of 2 on the Power Mac when bitblitting (showing
% each image).
%
gFrameRate = 200/3

% Load the stimulus images, if not already loaded
%
if (~exist('bitimage'))
   disp('Loading gaborImages')
   [bitimage,m,n,nimages]=LoadBitImage('gaborImages');
end

% Make sure we're in the experiment directory
%
eval (['cd ','''',gRoot,'Experiments:Color','''']);

% Load the colormap if it doesn't exist and scale it for SCREEN
%
if (~exist('cmap'))
	disp('Loading cmap110496')
	load cmap110496
end
% Scale the colormap for SCREEN - must have values between 0 and 255
cmap(1,:) = zeros(1,size(cmap,2));		% Set first entry to 0 (black)
cmap(256,:) = 255*(ones(1,size(cmap,2)));	% Set last (256th) entry to 255 (white)
cmap(2:255,:) = round(scale(cmap(2:255,:),1,254));	% Scale remaining values between 1 and 254

% Don't use the gamma map, we have already accounted for it
contrast = 2;

% Temporal frequency
flickerRate = 4;
numofexps = 6;		% number of scans
predur=9;			% Duration in secs before first pulse
nreps=6;            % number of stimulus repetitions per scan

ISI = 26.64;				% Inter-stimulus-interval in sec
impdur = 15.36;			% Length of stimulus impulse in sec
cycledur = impdur+ISI;	% Length of one cycle in sec
expDuration = predur+(cycledur*nreps)	% Scan duration in sec
fmriFrames = expDuration/3		% Number of fMRI frames (images collected)

% Make the initial blank period sequence
%
preseq = [1 -1*(ones(1,getframes(predur)-1))];

% Make the stimulus sequence (impseq) for one second duration
% (3 phosphors, 2 color directions)
%
nContrastLevels = size(cmap,2)/(3*2);

% To make things time out properly, we don't necessarily use all
% of the input contrast levels
%
nLevelsUsed = floor(gFrameRate/flickerRate);
step = nContrastLevels/nLevelsUsed;

impseq = round([-1:-step:-nContrastLevels]);
impseq = kron(impseq,ones(flickerRate,1));
impseq = impseq'; impseq = impseq(:);

% Expand the stimulus sequence (impseq) to impdur seconds
impseq = impseq(:,ones(1,ceil(impdur)));
impseq = impseq(:)';

% Make the ISI sequence
% (Subtract 1 to compensate for loading image at beginning of
% each impseq)
%
isiseq = [-1*ones(1,getframes(ISI)-1)];

% This sets the order of spatial images
stimOrder = [5 2 4 3 1 6];

for exp = 1:numofexps
	seq = preseq;
	if exp == 1;
		for i=1:3
		  seq = [seq stimOrder(i) impseq isiseq];
		  seq = [seq stimOrder(i) (impseq - 32) isiseq];
		end
	elseif exp == 2
		for i=4:6
		  seq = [seq stimOrder(i) impseq isiseq];
		  seq = [seq stimOrder(i) (impseq - 32) isiseq];
		end
	elseif exp == 3
		for i=3:-1:1
		  seq = [seq stimOrder(i) (impseq - 32) isiseq];
		  seq = [seq stimOrder(i) impseq isiseq];
		end
	elseif exp == 4
		for i=6:-1:4
		  seq = [seq stimOrder(i) (impseq - 32) isiseq];
		  seq = [seq stimOrder(i) impseq isiseq];
		end
	elseif exp == 5
		for i=1:3
		  seq = [seq stimOrder(i) (impseq - 32) isiseq];
		  seq = [seq stimOrder(i) impseq isiseq];
		end
	else
		for i=4:6
		  seq = [seq stimOrder(i) (impseq - 32) isiseq];
		  seq = [seq stimOrder(i) impseq isiseq];
		end
	end
	nframes=length(seq);
	
% Check to see if seq corresponds to expected duration of experiment
%
	seqDuration = nframes/gFrameRate
	if abs(expDuration - seqDuration) > 1
		sprintf('Experiment duration %f sec does not equal sequence length %f sec', ...
		expDuration,seqDuration)
		break
	end
	
	fmriFrames=round(expDuration/3)

% Start running experiment
%
	txt=sprintf('Gabor Exp %d: %f seconds, Scanner Images:  %d', ...
	   exp,expDuration,fmriFrames);

	 err = -1;
	 gBkcolor=127;		
	 while (err ~=0)
	 	err=runhb(bitimage,m,n,seq,nframes,contrast,cmap,txt);	 
		pause(1);
	 end

end
