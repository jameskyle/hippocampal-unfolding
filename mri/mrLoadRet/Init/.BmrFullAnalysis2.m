function mrFullAnalysis(buttonid,inpstr,curSer)
%mrFullAnalysis.m
%
%	Performs an analysis of fMRI results, from 'P files' to correlational maps.
%	To be used with mrLoadRet.
%
%	The following conventions are used for storage of data files:
%
%	/grey/u3/mri/raw        raw P?????? files, sg* files
%	/grey/u3/mri/recon	garyrecon2
%	a matlab directory	Can be empty from start.  Will hold
%				ExpParams.mat anat.mat tSeries*.mat and CorAnal.mat
%
%	mrFullAnalysis needs, at a minumum:
%	1) anatomy directory (somewhere on white's system)
%	2) raw P????? files in /grey/u3/mri/raw
%	Note: current directory is the matlab directory by default.

%	12/18/95	gmb	Wrote it.
%	6/2/96		gmb	Revised to avoid I files and sent old version to mrFullAnalIfiles.m
%	6/5/96 		gmb 	Added loop which waits for all tSeries files to be generated.
%           			This allows for multiple reconstructions in parallel.
%       7/24/96         gmb abp Allow for different P file locations.
%       8/15/96         gmb     Allow for different recon executables.       
%       9/2/96          gmb     Added calculate flat anatomy, 
%                               time series, and correlations.
%       12/2/96         gmb     Added 'grev' variable to copy
%                               over appropriate trajectory file.
%       12/30/96        gmb     Changed defaults: interleaves=2, FOV=26
%        3/26/97        gmb     Added capability to reconstruct
%                               from 3d spiral scans with 3dcode       
%        8/6/97         djh     Modified to save dc in CorAnal.mat
%       09.30.97        abp     Can now save the first Pfile image.
%                               This is used when checking for a shift between
%                               anatomy images and functionals
%       01.05.98        hab     Updated for matlab5 (changed ~= to ~isempty)
%	04.14.98	sjc	Added 'calculate 3D correlations' and
%				'create OFF files' as steps 10 and 11 in full analysis
%	05.15.98	sjc	Eliminated 'create OFF files' because they will not be
%				created in mrLoadRet
%	05.19.98	sjc	Added code to create 'layer1map' if it is not found in
%				'flat.mat'
%	07.07.98	bw,sjc  Added a comment and unfdir to be saved out in
%				FCorAnal_HEMISPHERE so that it contains the directory
%				of the flattened file that was used to create it. 
% 				Also added unfoldSubDir as an input parameter to the
%				function so that one of several unfolds of the same
%				gray matter can be specified.  Also added the loading
%				of AlignParams.mat to get the subject name.

qt='''';		 	% String of single quote '
err=0;			 	% Output of Unix commands
noDataVal = -99;		% Value for points with no fMRI data
flag3dcode = 0;                 % Flag for using 3dcode to convert
                                % Pfiles from 3d to 2d.  Default is 'no'.
a_header = 1; 			% Whether or not there is a header on the anatomy image 
oSize = [256 256]; 		% Size of inplanae anatomy images
funcSize = [256,256];           % Size of functional images
anatmap = []; 			% Map connecting anats to funs
rawdr=pwd; 			% Directory of raw P files by default
sgdr='/grey/u3/mri/raw';  	% Directory of sg (trajectory) files
interleaves = 2;		% Number of interleaves (default)
FOV = 26;			% Field of view (default)
grev = 9;                       % gradient waveform revision (default)
scriptdr='/grey/u2/mri/scripts';	% Directory of scripts
recondr = '/grey/u2/mri/recon/';  % directory of recon program
sunreconname = 'grecon20-sun';  % name of recon program for SUN
                                %(used to be grecon2 before 8/15/96)
hpreconname  = 'grecon20-hp';   % name of recon program for HP
sun3dcodename = '3dcode-sun';   % name of 3dcode program for SUN
hp3dcodename = '3dcode-hp';     % name of 3dcode program for HP
matdr=pwd;		 	% Directory of Matlab files
nsteps=size(inpstr,1);		% Nine easy steps for data analysis

for i=1:nsteps
  step(i)=get(buttonid(i),'Value');
end

figure(1)

%Gather some more information (if needed).

%Get reconstructed functional image size
if (step(1)==1 | step(2)==1)
  disp(['Default functional image dimensions is [',...
	      int2str(funcSize(1)),',',int2str(funcSize(2)),'].']);

  inputval = input ('Press <return> to accept, or enter a new size: ');
  if ~isempty(inputval)
    funcSize = inputval;
  end
end

%Convert Pfiles from 3d to 2d?
if (step(2)==1) 
  inputstr=input('Convert P files from 3d to 2d (y/n)? ','s');
  if (inputstr(1)=='y' | inputstr(1)=='Y')
    flag3dcode =1;
  else
    flag3dcode =0;
  end
end

%Get list of P file names
if (step(2)==1 | step(4)==1)
  disp(['Directory of P files is ',rawdr]);
  inputdr = input ('Press <return> to accept, or enter a new directory: ','s');
  if ~isempty(inputdr)  % hab
    rawdr = inputdr;
  end
  
 
  disp(['Default number of interleaves is ',num2str(interleaves)]);
  tmp=input('Press <return> to accept, or enter a new value: ');
  if size(tmp)
    interleaves = tmp;
  end
  
  disp(['Default FOV is ',num2str(FOV)]);
  tmp=input('Press <return> to accept, or enter a new value: ');
  if size(tmp)
    FOV = tmp;
  end
  
  %Get the reconstruction executable (grecon) name
  
  %Determine which computer we're using
  
  whichmachine=computer;
  if (whichmachine(1)=='S') 
    recon=[recondr,sunreconname]; 	%we're on a Sun
    nameof3dcode = [recondr,sun3dcodename];
  elseif (whichmachine(1)=='H')  
    recon=[recondr,hpreconname]; 	%no, we're on an HP
    nameof3dcode = [recondr,hp3dcodename];
  else
    disp(['I don',qt,'t recognize the computer ',qt,whichmachine,qt,'.']);        
    chdir(matdr);
    return
  end
  
  %allow user to enter alternate reconstruction script
  disp([' ']);
  disp(['Default recon path and file is ',qt,recon,qt,'.']);
  disp(['Current options are:']);
  if (whichmachine(1)=='H')
    unix(['ls -m ',recondr,'*hp']);
  elseif (whichmachine(1)=='S')
    unix(['ls -m ',recondr,'*sun']);
  end
  tempstr=input('Press <return> to accept, or enter an alternate: ','s');
  if (length(tempstr))
    recon=tempstr;
  end
  
  %build trajectory file name
  
  %trajectory file names are of the form:
  %sg<a>_<b>_<c>.kk,  where:
  %<a> is the 'grev', or gradient waveform revision
  %grev = 9 for 2 interleaves.  grev = 5 for 4 interleaves
  %<b> is the number of interleaves
  %<c> is the Field of View
  %<c> = 20 if FOV < 32
  %<c> = 32 if FOV >= 32
  
  % Determine grev:
  if interleaves == 2 | interleaves == 1
    grev  = 9;
  else
    grev = 5;
  end
  
  sgname = ['sg',int2str(grev)];
  
  %Tack on interleaves
  sgname = [sgname,'_',int2str(interleaves)];
  
  %Tack on FOV, (decision rule complements of Gary Glover)
  if FOV <32
    sgname = [sgname,'_20.kk'];
  else
    sgname = [sgname,'_32.kk'];
  end
  
  sgname
  
  %Copy the trajectory file over to the Pfile directory

  %copy trajectory file into rawdr
  str=['err = unix(',qt,'cp ',sgdr,'/',sgname,' ',rawdr,qt,');'];
  disp(str)
  
  eval(str)
  if (err==1)
    disp(['Cannot copy file ',sgdr,'/',sgname]);
    chdir(matdr);
    return
  end
  chdir(rawdr)
  
  str= ['[foo,Pname]=unix(',qt,'ls P?????',qt,');'];
  eval(str);
  nPfiles=length(Pname)/7;
  if nPfiles<1
    disp(['No P files found in directory ',rawdr,'!']);
    return
  end	
  Pname=reshape(Pname,7,nPfiles)';
  Pname=Pname(:,1:6);
  %Let the user decide which P file on the list to recon
  disp(' ');
  disp('Which P files do you want to reconstruct?');
  for i=1:nPfiles
    disp(['(',int2str(i),') ',Pname(i,:)]);
  end
  Plist=input('Enter a vector (i.e. [1,2,5]), or press <return> for all: ');
    %default is to recon all P files
    if isempty(Plist)
      Plist=1:nPfiles;
    end
    
  end
% Linear trend for computing correlations?
if (step(3)==1 | step(7) ==1)
  ltrend=input('Subtract linear trend before correlation analysis? (y/n) ','s');
end

% Which hemishpere(s) and unfold to analyze?
if (step(5)==1 | step(6)==1 | step(7)==1 | step(10)==1)

  % Get hemisphere
  side = input('Analyze [l]eft, [r]ight, or [b]oth hemispheres?  ','s');
  if isempty(side)
    side = 'b';
  end
  
  % We need to get the subject from AlignParams.mat
  load AlignParams
  
  % Get unfold subdirectory(ies)
  if ((side == 'b') | (side == 'l'))
    leftUnfDir = ['/usr/local/mri/anatomy/' subject '/left/unfold'];
    chdir(leftUnfDir);
    
    % Display choices
    fprintf('Available left unfold subdirectories:');
    ls -p
    leftUnfoldSubDir = input('Which left unfold subdirectory?');
    
    % Check to see if the subdirectory exists
    if ~(exist([leftUnfDir '/' leftUnfoldSubDir]) == 2)
      leftUnfoldSubDir = '';
    end
  else
    leftUnfoldSubDir = '';
  end
  
  if ((side == 'b') | (side == 'r'))
    rightUnfDir = ['/usr/local/mri/anatomy/' subject '/right/unfold'];
    chdir(rightUnfDir);
    
    % Display choices
    fprintf('Available right unfold subdirectories:');
    ls -p
    rightUnfoldSubDir = input('Which right unfold subdirectory?');
    
    % Check to see if the subdirectory exists
    if ~(exist([rightUnfDir '/' rightUnfoldSubDir]) == 2)
      rightUnfoldSubDir = '';
    end
  else
    rightUnfoldSubDir = '';
  end
  chdir(matdr);
end


% Post-analysis script?
if (step(8)==1)
  disp('Enter the directory of the post-analysis script')
  PostAnalDr=input(['Default is ',matdr,' '],'s');
  if PostAnalDr == ''
    PostAnalDr = pwd;
  end
  disp('Enter the name of the post-analysis script');
  chdir(PostAnalDr);
  disp('Current options are:');
  unix('ls *.m');
  PostAnalName = input('Name: ','s');
  ln = length(PostAnalName);
  %strip off '.m' if necessary
  if ln >=3
    if strcmp(PostAnalName((ln-1):ln),'.m') == 1
      PostAnalName = PostAnalName(1:ln-2);
    end
  end
  chdir(matdr);
end  

if (step(9) == 1)
  errn = 2;		% error number == 2 when file creation fails
  while (errn ~=0 ) 	% error number == 0 for success
	pfdr = sprintf('%s/%s',rawdr,'anatomy/Pfiles');
	str = sprintf('\nDefault directory to save first image of Pfiles:');
	disp(str);
	str =sprintf('\n\t%s',pfdr);
	disp(str);
	inputdr = input('Press <return> to accept, or enter a new directory: ','s');
%	if inputdr ~= ''
	if ~isempty(inputdr)  %  hab
	  pfdr = inputdr;
	end
	% Make it right here 
	inputyn = input('Create directory? ([y]/n): ','s');
	if ( (inputyn == 'y') | (inputyn == '') )
		str= ['[errn,junk]=unix(',qt,'mkdir ',pfdr,qt,');'];
		eval(str);
	else
		errn = 0;
	end
  end
end

%Check that anatomy is clipped before calculating tSeries
chdir(matdr);
load anat
if curSize==[256,256] & step(1)==0 & step(2)==1
  disp('Anatomy should be clipped before calculating tSeries');
  yn=input('Clip the anatomies? (y/n) ','s');
  if yn(1)=='y' | yn(1)=='Y'
    step(1)=1;
  end
end

% Get name(s) of gray file(s) and check validity, get the layer 1 map(s)
if (step(10)==1)
  mrLoadAlignParams		% To get the subject name
  grayDir = ['/usr/local/mri/anatomy/' subject];
  
  if ((side == 'b') | (side == 'l'))
    % Get gray file
    leftGrayFile = input('Enter left gray matter file name (e.g. leftGray.dat): ','s');
    if (isempty(leftGrayFile) | ~exist([grayDir '/left/' leftGrayFile]))
      error('mrFullAnalysis: Invalid left gray matter file.')
    end
    
    % Get layer1map
    estr = sprintf('load %s/left/unfold/flat',grayDir);
    disp(estr)
    eval(estr)
    if (exist('layer1map') ~= 1)
      fprintf('''layer1map'' not found in %s/left/unfold/flat.\n',grayDir);
      disp('Creating layer1map for left hemisphere and saving it as part of ''flat.mat''')
      leftLayer1map = createLayer1Map(grayDir,'vAnatomy.dat','left',leftGrayFile);
      chdir(matdr);
    else
      leftLayer1map = layer1map;
      clear layer1map
    end
  end
  
  if ((side == 'b') | (side == 'r'))
    % Get gray file
    rightGrayFile = input('Enter right gray matter file name (e.g. rightGray.dat): ','s');
    if (isempty(rightGrayFile) | ~exist([grayDir '/right/' rightGrayFile]))
      error('mrFullAnalysis: Invalid right gray matter file.')
    end
    
    % Get layer1map
    estr = sprintf('load %s/right/unfold/flat',grayDir);
    disp(estr)
    eval(estr)
    if (exist('layer1map') ~= 1)
      fprintf('''layer1map'' not found in %s/right/unfold/flat.\n',grayDir);
      disp('Creating layer1map for right hemisphere and saving it as part of ''flat.mat''')
      rightLayer1map = createLayer1Map(grayDir,'vAnatomy.dat','right',rightGrayFile);
      chdir(matdr);
    else
      rightLayer1map = layer1map;
      clear layer1map
    end
  end
end

%************************ Begin analysis ************************************

%Load in experimental parameters
chdir(matdr);
load ExpParams
load anat

for stepnum=1:nsteps
  
  %%%%%%%%%%%%%%%%%%%%%% Step 1, Clip and Save Anatomies  
  
  if (stepnum==1 & step(stepnum)==1)
    % *** Load Anat ***
    [anat, anatmap, curSize, curDisplayName] = ...
	mrLoadAnatRet(oSize, numofanats, numofexps, a_header, anatmap);
    % *** Clip Anat ***
    [curImage, curSize, curCrop, anat] = mrClipAnatRet(anat, oSize,anatmap,curSer);		
    % *** Save Anat ***
    chdir(matdr);
    if funcSize(1)==256
      mrSaveAnatRet(anat, anatmap, oSize, curSize, curCrop,'anat');
    else
      mrSaveAnatRet(anat, anatmap, oSize, curSize, curCrop,'anat256');
      [anat,curSize,curCrop] =mrDownSampleAnat(anat,curSize,curCrop,2);
      mrSaveAnatRet(anat, anatmap, funcSize, curSize, curCrop,'anat');
    end
  end
  
  %%%%%%%%%%%%%%%%%%%%%% Step 2 Calculate tSeries from P files
  if (stepnum==2 & step(stepnum)==1)	
    %Loop through P files on the list
    for curPfile=Plist
      %convert Pfiles from 3d to 2d if requested
      if (flag3dcode ==1)
	if ~check4File([ Pname(curPfile,:),'.3d'])
	  str = (['err =unix(',qt,'mv ', Pname(curPfile,:),' ', Pname(curPfile,:),'.3d',qt,');']);
	  disp(str);
	  eval(str);
	  if err == 1
	    disp(['*** Error moving ', Pname(curPfile,:),' to ', Pname(curPfile,:),'.3d']);
	    return
	  end
	end
	% do the conversion with Gary's '3dcode'
	str = ['err = unix(',qt,nameof3dcode,' ', Pname(curPfile,:),'.3d ', Pname(curPfile,:),qt,');'];
	disp(str);
	eval(str);
	if err == 1
	  disp(['*** Error converting ', Pname(curPfile,:),'.3d from 3d to 2d with ',nameof3dcode]);
	  return
	end
      end

      %recon the current P file using grecon2
      chdir(rawdr);
      str=['Reconstructing ',Pname(curPfile,:)];
      disp(str);
      estr=['err = unix(',qt,recon,' ',Pname(curPfile,:),qt,');'];
      eval(estr);
      if (err==1)
	disp(['*** Error reconstructing scan number ',int2str(curPfile),', ',Pname(curPfile,:),' ***']);	   	return
      end
      %Create the TSeries from reconstructed images
      chdir(matdr); 
      for i=1:numofanats
	tSeriesnum=curPfile+(i-1)*(numofexps/numofanats);
	disp(['Creating tSeries',num2str(tSeriesnum)]);
	imageList=((i-1)*imagesperexp+1):(i*imagesperexp);
	tSeries = mrSeries( rawdr, imageList, funcSize, curCrop, 0 ,Pname(curPfile,:));
	str=['Saving tSeries',num2str(tSeriesnum)];
	disp(str);
	estr = ['save tSeries',num2str(tSeriesnum), ' tSeries'];
	eval(estr);
      end				

      %Clean up the extra files that are lying around.
      
      %Remove reconstructed images from the raw directory (P*.???)
      chdir(rawdr);
      % Hold onto the first Pfile if requested
      if (step(9) == 1)
	      if check4File([Pname(curPfile,:),'.1000'])
		estr=['err = unix(',qt,'mv ',Pname(curPfile,:),'.0001 ',pfdr,qt,');'];
	      else
		estr=['err = unix(',qt,'mv ',Pname(curPfile,:),'.001 ',pfdr,qt,');'];
      	      end
	      eval(estr);
      end

      str=(['Removing ',Pname(curPfile,:),'.???*']);
      disp(str);
      estr=['err = unix(',qt,'rm ',Pname(curPfile,:),'.???',qt,');'];
      eval(estr);
      %Check for P number 1000
      if check4File([Pname(curPfile,:),'.1000'])
	estr=['err = unix(',qt,'rm ',Pname(curPfile,:),'.????',qt,');'];
	eval(estr);
      end
      if(err==1)
	disp(['*** Error deleting ',Pname(curPfile,:),' ***']);
	return
      end
      
      if check4File([Pname(curPfile,:),'.3d'])
	%Remove P????? if P?????.3d exists
	str = ['err = unix(',qt,'rm ',Pname(curPfile,:),qt,');'];
	eval(str);
	if err == 1
	  disp(['*** Error removing file ',Pname(curPfile,:)])
	  return
	end
      
	%Move P?????.3d to P????? 
	str= ['err = unix(',qt,'mv ',Pname(curPfile,:),'.3d ',Pname(curPfile,:),qt,');'];
	eval(str)
	if err == 1
	  disp(['*** Error moving ',Pname(curPfile,:),'.3d to ',Pname(curPfile,:)])
	  return
	end
      end
    end
    chdir(matdr);
  end
  
  %%%%%%%%%%%%%%%%%%%%%% Step 3 Calculate correlations
  if (stepnum==3 & step(stepnum)==1)
    chdir(matdr);
    %First, check to see if all tSeries are there.
    %if not, keep checking every minute
    go_ahead=0;
    while go_ahead==0

      estr=(['[foo,foobar]=unix(',qt,'ls tSeries*.mat | wc -l',qt,');']);
      eval(estr);
      num_tSeries = str2num(foobar);
      if numofexps==num_tSeries
	go_ahead=1;
      else
	disp(['Found only ',num2str(num_tSeries), ' tSeries files.']);
	disp(['Waiting to find all ',num2str(numofexps),'...']);
	pause(60);
      end
    end
    disp(['Found all ',num2str(num_tSeries), ' tSeries files.']);
    
    clear co ph amp dc;
    [co,ph,amp,dc]=mrCorRet(numofexps, imagesperexp, ncycles ,junkimages,ltrend);
    
    disp(['Saving Correlation Matrices']);
    str=['save CorAnal co ph amp dc'];
    eval(str);
  end
  
  %%%%%%%%%%%%%%%%%%%%%% Step 4, compress P files.
  if (stepnum==4 & step(stepnum)==1)
    chdir(rawdr);
    for curPfile=Plist
      str=['Compressing ',Pname(curPfile,:)];
      disp(str);
      estr=['err = unix(',qt,'gzip -r ',Pname(curPfile,:),qt,');'];
      eval(estr);
      if (err==1)
	disp(['*** Error:  while compressing ', Pname(curPfile,:)]);
	chdir(matdr);
	return
      end
    end
    chdir(dr);
  end
  
  %%%%%%%%%%%%%%%%%%%%%% Step 5, Create flattened anatomy.
  if (stepnum==5 & step(stepnum)==1)
    if ((side == 'b') | (side == 'l'))
      mrCreateFlatAnat2(side,leftUnfoldSubDir);
    end
    if ((side == 'b') | (side == 'r'))
      mrCreateFlatAnat2(side,rightUnfoldSubDir);
    end
  end
  
  %%%%%%%%%%%%%%%%%%%%%% Step 6, calculate flattened time series.
  if (stepnum==6 & step(stepnum)==1)
    chdir(matdr);
    %First, check to see if all tSeries are there.
    %if not, keep checking every minute
    go_ahead=0;
    while go_ahead==0
      estr=(['[foo,list]=unix(',qt,'ls tSeries*.mat',qt,');']);
      eval(estr);
      %count the number of .'s in the list
      num_tSeries=sum(list=='.');
      if numofexps==num_tSeries
	go_ahead=1;
      else
	disp(['Found only ',num2str(num_tSeries), ' tSeries files.']);
	disp(['Waiting to find all ',num2str(numofexps),'...']);
	pause(60);
      end
    end
    disp(['Found all ',num2str(num_tSeries), ' tSeries files.']);
    mrMakeFTSeries(side);
  end
  
  %%%%%%%%%%%%%%%%%%%%%% Step 7, calculate flattened 
  %correlation, phase, and
  %amplitude matrices.
  
  if (stepnum==7 & step(stepnum)==1)
    chdir(matdr);
    mrFCorRet(numofexps/numofanats, imagesperexp, ncycles, junkimages,ltrend,side);
  end

  %%%%%%%%%%%%%%%%%%%%%% Step 8, post-analysis script
  if (stepnum==8 & step(stepnum)==1)
    chdir(PostAnalDr);
    eval(PostAnalName);
    chdir(matdr);
  end
  
  %%%%%%%%%%%%%%%%%%%%%% Step 9, save first Pfile image
  % nothing more to do for step 9, everything is done in first part of function
  
  %%%%%%%%%%%%%%%%%%%%%% Step 10, calculate 3D correlations
  if (stepnum==10 & step(stepnum)==1)

    if ((side == 'b') | (side == 'l'))
      [leftXYZ_layer_amp_co_ph_dc,leftbimage,leftUnfList]=...
        mrFlat2volDat(matdr,grayDir,'l',leftGrayFile,noDataVal);
          
      [leftXYZ_amp_co_ph_dc,noDataCount] = ...
    	mrCompressData(leftXYZ_layer_amp_co_ph_dc,leftLayer1map,noDataVal);
    	
      chdir(matdr)
      fprintf('Saving data in %s/VCorAnal_left.mat...\n',matdr);
      save VCorAnal_left leftXYZ_amp_co_ph_dc
      disp('Finished compressing left hemisphere data to first layer.')
    end
    
    if ((side == 'b') | (side == 'r'))
      [rightXYZ_layer_amp_co_ph_dc,rightbimage,rightUnfList]=...
        mrFlat2volDat(matdr,grayDir,'r',rightGrayFile,noDataVal);

      [rightXYZ_amp_co_ph_dc,noDataCount] = ...
    	mrCompressData(rightXYZ_layer_amp_co_ph_dc,rightLayer1map,noDataVal);
          
      chdir(matdr)
      fprintf('Saving data in %s/VCorAnal_right.mat...\n',matdr);
      save VCorAnal_right rightXYZ_amp_co_ph_dc
      disp('Finished compressing right hemisphere data to first layer.')
    end
    %end
  end
  
  %%%%%%%%%%%%%%%%%%%%%% Finished all steps
  
  set(buttonid(stepnum),'Value',0);
end
chdir(matdr);
disp('mrFullAnalysis: done.');
  
  

  
  
