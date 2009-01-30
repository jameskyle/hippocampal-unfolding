function mrFullAnalIfiles(buttonid,inpstr,curSer)
%mrFullAnalysis.m
%
%	Performs an analysis of fMRI results, from 'P files' to correlational maps.
%	To be used with mrLoadRet.
%
%	The following conventions are used for storage of data files:
%
%	/gusr3/mri/raw		raw P?????? files, sg* files
%	/gusr3/mri/scrips	autounpack.sh, autotapebackup.sh
%	somewhere on path	garyrecon
%	a matlab directory	Can be empty from start.  Will hold
%				ExpParams.mat anat.mat tSeries*.mat and CorAnal.mat
%	image file directory 	Must hold directory with structure 'anatomy/inplanes/I.???'
%				Will hold all image directories and files (exp*/I.*)
%
%	mrFullAnalysis needs, at a minumum:
%	1) anatomy directory (somewhere on white's system)
%	2) raw P????? files in /gusr3/mri/raw
%	Note: current directory is the matlab directory by default.
%
%	12/18/95	gmb	Wrote it.


qt='''';		 	% String of single quote '
err=0;			 	% Output of Unix commands
a_header = 1;     	 	% Whether or not there is a header on the anatomy image 
oSize = [256 256]; 		% Size of full anatomies
anatmap = [];		 	% Map connecting anats to funs
rawdr='/gusr3/mri/raw';  	% Directory of raw P files
scriptdr='/gusr2/mri/scripts';	% Directory of scripts
matdr=pwd;		 	% Directory of Matlab files
nsteps=size(inpstr,1);		% Eight easy steps for data analysis

for i=1:nsteps
	step(i)=get(buttonid(i),'Value');
end

figure(1)

%Gather some more information (if needed).

%Get P file names
if (step(3)==1 | step(4)==1) 
	chdir(rawdr);
	str=['err = unix(',qt,'ls -l P?????',qt,');'];
	eval(str);
	tempstr='';
	tempstr =           input ('Name of first P file: ' ,'s');
	if (size(tempstr)) 
		P1=tempstr;
	end
	
	tempstr='';
	tempstr =           input ('Name of last P file:  ' ,'s');
	if (size(tempstr)) 
		P2=tempstr;
	end
end

% Linear trend for computing correlations?
if (step(6)==1)
	ltrend=input('Subtract linear trend before correlation analysis? (y/n) ','s');
end

if (step(5)==1 & step(7)==1)
	compressAsUGo=input('Compress image files along the way? (y/n) ','s');
else
	compressAsUGo='n';
end

% Tape backup tar file number
if (step(8)==1)
	backnum=input('Tar file number for tape backup: ');
	disp('Be sure the tape is in the drive.');
end

%Wait here if file 'wait' exists.
%Why wait?  Often I reconstruct P files using multiple machines in parallel.
%After reconstruction I'd like to run 'Full Analysis'.  However It's usually around
%4 in the morning when the P files are finished, and I can't run mrLoadRet
%easily from home.  With 'wait', I run mrLoadRet's 'Full Analysis' from my desk 
%before I go home at night after placing a file named 'wait' in the directory.  
%Then I get up in the middle of the night, log in and remove the file to continue 
%the analysis.  Cheezy?  You betcha.

while (unix(['test -f ',matdr,'/wait'])==0)   % file exists, so load it in
	disp('Waiting for removal of file "wait" ...');
	pause(60); %wait for a minute
end



%************************ Begin analysis ************************************


for stepnum=1:nsteps
    if(step(stepnum)==1)
	    disp(['********************* ',inpstr(stepnum,:),' ********************']);
    end

    %%%%%%%%%%%%%%%%%%%%%% Step 1, Enter Inital Parameters
    if (stepnum==1) 
	if (step(1)==1)
		mrGetInitParams;
	end
	chdir(matdr);
	str=['load ExpParams'];
	disp(str);
	eval(str)
    end


    %%%%%%%%%%%%%%%%%%%%%% Step 2, Clip and Save Anatomies  

    if (stepnum==2)
	if (step(2)==1)
		% *** Load Anat ***
		[anat, anatmap, curSize, curDisplayName] = ...
		mrLoadAnatRet(oSize, numofanats, numofexps, a_header, anatmap);
		% *** Clip Anat ***
		[curImage, curSize, curCrop, anat] = mrClipAnatRet(anat, oSize,anatmap,curSer);		
		% *** Save Anat ***
		chdir(matdr);
		mrSaveAnatRet(anat, anatmap, oSize, curSize, curCrop);
	else
		chdir(matdr);
	    	str=['load anat'];
	    	eval(str);
	end
    end
    %%%%%%%%%%%%%%%%%%%%%% Step 3, Recon P files

    if (stepnum==3 & step(stepnum)==1)
	%start the recon
	
	chdir(dr);

	str=['err = unix(',qt,'cp ',rawdr,'/sg5_4_20.kk .' ,qt,');'];
	eval(str)
	
	if (err==1)
		disp('Cannot copy file sg5_4_20.kk');
		chdir(matdr);
		return
	end

	str=['err = unix(',qt,'/gusr2/mri/recon/garyrecon2 ',P1,' ',P2,qt,');'];
	eval(str);

	if (err==1)
		disp('*** Error: Cannot reconstruct files.');
		chdir(matdr);
		return
	end

	%remove extraneous files.

	str=['err = unix(',qt,'rm B*',qt,');'];
	eval(str)

	str=['err = unix(',qt,'rm sg*',qt,');'];
	eval(str)
    end

    %%%%%%%%%%%%%%%%%%%%%% Step 4  Unpacking image files.
    if (stepnum==4 & step(stepnum)==1)

	%is P file P1 the first in the directory?
	%if not, we need to shift exp file names to start with exp0
	
	chdir(rawdr);
	str= ['[foo,Plist]=unix(',qt,'ls P?????',qt,');'];
	eval(str);
	
	Pnum=0;
	for i=1:(length(Plist)+1)/7
		if (sum(Plist((i-1)*7+1 : i*7-1) == P1)==6)
			Pnum=i;
		end
	end
	
	if (Pnum==0)
		disp(['*** Error:  Cannot find ',P1]);
		chdir(matdr);
		return
	end
	
	%Shift the exp file names to start with 'exp0'
	
	if (Pnum>1)	%shift only if first P file is not first on rawdr.
		chdir(dr);
		disp('Shifting exp file names.');	
		for i=0:(numofexps/numofanats-1)
			str=['err=unix(',qt,'mv exp',num2str(i+Pnum-1),' exp',num2str(i),qt,');'];
			disp(str);
			eval(str);
			if (err==1)
				disp(['*** Error: while moving directory ',qt,'exp',num2str(i+Pnum-1),qt]);
				chdir(matdr);
				return
			end
		end
	end

	%Now call 'autounpack.sh'
	chdir(dr);

	str=['err = unix(',qt,scriptdr,'/autounpack.sh ', ...
		num2str(numofexps/numofanats),' ',num2str(numofanats),' ',num2str(imagesperexp),qt,');'];
	eval(str);

	if (err==1)
		disp(['*** Error: unable to unpack after reconstruction']);
		chdir(matdr);
		return
	end
    end

    %%%%%%%%%%%%%%%%%%%%%% Step 5 Crop images and calculate TSeries
    if (stepnum==5 & step(stepnum)==1)
	chdir(matdr)
	mrMakeTSeries(numofexps,imagesperexp,[256,256],curCrop,compressAsUGo);
    end

    %%%%%%%%%%%%%%%%%%%%%% Step 6  Calculate correlations
    if (stepnum==6 & step(stepnum)==1)
	chdir(matdr);

	clear co ph amp;
	[co,ph,amp]=mrCorRet(numofexps, imagesperexp, ncycles ,junkimages,ltrend);
	
	disp(['Saving Correlation Matrices']);
	str=['save CorAnal co ph amp'];
	eval(str);
    end

    %%%%%%%%%%%%%%%%%%%%%% Step 7, compress I files.
    if (stepnum==7 & step(stepnum)==1)
	chdir(dr);
	for i=1:numofexps
		disp(['experiment ',num2str(i)]);
		str=['err = unix(',qt,'gzip -r exp',num2str(i),'/I.*',qt,');'];
		eval(str);
		if (err==1)
			disp('*** Error:  while compressing I.* files');
			chdir(matdr);
			return
		end		
	end
	%compress anatomical images
	str=['err = unix(',qt,'gzip -r anatomy/*/I.*',qt,');'];
	eval(str);
	if (err==1)
		disp('*** Error:  while compressing anatomy images');
		chdir(matdr);
		return
	end
    end

    %%%%%%%%%%%%%%%%%%%%%% Step 8,Tape Backup.

    if (stepnum==8 & step(stepnum)==1)

	%First check to see if tape is being backed up.
	chdir(rawdr);
	while exist('tapeinuse.mat')
		disp('Tape backup in use.  Waiting for completion ...');
		pause(10);
	end
	
        % 6/30/97 Lea updated to 5.0
	save tapeinuse backnum -v4
	str=['err = unix(',qt,'rsh brown ',scriptdr,'/autotapebackup.sh ',num2str(backnum),' ',dr,qt,');'];
	disp(str);
	eval(str)
	
	%remove tapeinuse flag.
	str=['err = unix(',qt,'rm tapeinuse.mat',qt,');'];
	eval(str);	

	if (err==1)
		disp('*** Error: tape backup failed');
	end

    end
    set(buttonid(stepnum),'Value',0);
end
chdir(matdr);

disp('done.');

