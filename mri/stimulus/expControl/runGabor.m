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
% Move this to other cmap routine
%

% Set first entry to 0 (black)
cmap(1,:) = zeros(1,size(cmap,2));		
% Set last (256th) entry to 255 (white)
cmap(256,:) = 255*(ones(1,size(cmap,2)));	
% Scale remaining values between 1 and 254
cmap(2:255,:) = round(scale(cmap(2:255,:),1,254));	

% Don't use the gamma map, we have already accounted for it
contrast = 2;

% Make the initial blank period sequence
%
predur=9;			% Duration in secs before first pulse
preseq = [1 -1*(ones(1,getframes(predur)-1))];



% number of scans
numofexps = 6;		
% number of stimulus repetitions per scan
nreps=6;            
% Inter-stimulus-interval in sec
ISI = 26.64;				
% Length of one cycle in sec
cycledur = impdur+ISI;	
% Scan duration in sec
expDuration = predur+(cycledur*nreps)	
% Number of fMRI frames (images collected)
fmriFrames = expDuration/3	


% Each color map represents a color direction at some contrast
% The color map for this experiment consisted of two color
% directions, and we figure out how many contrast.
%
nContrastLevels = size(cmap,2)/(3*2);
flickerRate = 4;

% Length of stimulus impulse in sec
impdur = 5.;			
% Experimental display's frame frate
gFrameRate = 200/3

% This builds the flicker sequence for the stimulus duration
%
seq = flickerSeq(nContrastLevels, flickerRate, impdur, gFrameRate);
% plot(seq)

% Make the inter-stimulus-interval (ISI) sequence
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
	txt=sprintf('Gabor Exp %d: %.2f seconds, Scanner Images:  %d', ...
	   exp,expDuration,fmriFrames);

	 err = -1;
	 gBkcolor=127;		
	 while (err ~=0)
	 	err=runhb(bitimage,m,n,seq,nframes,contrast,cmap,txt);	 
		pause(1);
	 end

end
