%  mrLoadRet
%	 mrLoadRet()
%
%	Loads in anatomies, and displays them.  Prompts user for clip regions,
%	and loads in functional data series clipped to those regions.
%	Performs correlational analyses on the functional data and provides
%	a number of tools for visualizing the results.
%	
%		Variable Declarations
%               ---------------------

%Edits:

% 12/20/96	gmb	Added 'Full Analysis' option
% 01/19/96	gmb	slimin and slimax now varies with current anatomy slice.
%        This required changes in mrCreateExpBtns.m and mrNewExpBtn.m
% 06/11/96	gmb	Added 'ROI' as a member of curDisplayName
%			This required changes to mrSlicoControlRet.m
%6/11/96	gmb	Fixed annoying repetition of 'Correlation threshold set to ...'
% 			By modifying mrSlicoControlRet.m to take a 10th parameter
%9/5/96         gmb     Added ability to display data on the
%                       flattened cortical representation.
%1/23/97        gmb     Implemented bw's suggestion to put graphs in a second window.
% 03.12.97      ABP     Added a host of colormap entries under own
%                       pulldown menu.
% 06.19.97     LL, ABP   Started converting to matlab5.0
% 7.30.97       DJH     Added plotMeanTSeries and restrictROI
% 01.19.98      bw      Added viewPlane parameter to plotMeanTSeries
% 01.30.98       ABP    Added checkForShift (left out from 4.2c version)
% 02.12.98      rmk     Added 'ROI as dist' to ROIPlots
% 04.14.98	SJC	Added 'calculate 3D correlations' and
%			'create OFF files' as steps 10 and 11 in full analysis
% 04.16.98	SJC	Added 3D menu to compress data onto layer1 and save out
%			data in x,y,z, R,G,B format for rendering purposes
% 04.21.98	WAP	Added plotFftTSeries.  ROI FFT now matches ROI time
%			course options, including calculations over all slices

disp('mrLoadRet, version 1.0. Matlab 5.0 ');
disp('Initializing general workspace variables')

% Global Variables
% UI.dr, UI.slimin, UI.slimax, UI.slico, UI.axisflag;
% 
global dr slimin slimax slico axisflag

axisflag=1; %show axis by default

% Exp.numofexps, Exp.imagesperexp,Exp.ncycles;Exp.junkimages;
% Anatomy.numofanats, 

% 
% Local Variables that need to be changed often
% ---------------------------------------------
numofexps = 5;    	 % Number of experiments to be analysed together
imagesperexp = 96;	 % Number of functional images in each experiment
ncycles = 4; 		 % Number of ncycless in sinusoid to corellate with
			 % Note that "imagesperexp" should be an integer 
			 %     multiple of "ncycles" (I think).
numofanats = 1;		 % Number of anatomy images
junkimages = 4;	 	 % Number of frames to be thrown out

% Local variables that rarely need to be changed
% ----------------------------------------------
curSer = 1;		 % The current inplane of functional images.
oSize = [256 256];      % Both loadfun and loadanat use this -- ok?
curSize = oSize;  	 % Size of the current image
curCrop = 0;
a_header = 1;           % Whether or not there is a header on the anatomy image (1=y)
f_header = 0;		 % Whether or not there is a header on the functional images (1=y)
curImage = [];		 % The matrix of values corresponding to
loadRetWin = [];         % handle to the primary mrLoadRet window
graphWin = [];           % handle to the window to hold graphs


% intensity values of the current image
phase_cmap = [gray(128);hsv(128)];

curDisplayName = 'anatomy'; % The name of the current display presented
oldDisplayName = 'anatomy'; % The name of the previous display
viewPlane = 'inplane';  % current plane of viewing: 'inplane', 'left' or 'right'
qt = '''';              % single quote
sizeSS = [512,512];     % Size of the screen save image
ld = [];		 % Variable used in setting up menu bar (see code below)
anat = [];	 % Clipped anatomy images
anatmap = [];		 % Map connecting anats to funs
selpts = [];		 % The collection of point that comprise the Region Of Interest
selptsOld=[];            % The ROI before the most recent change for 'Undo' option
selpts_left = [];
selpts_right = [];
voldir = '/usr/local/mri/anatomy'; %location of volume anatomies
                                   % and flattened data

anatBtnList = [];	 % List of buttons used to change series.
expBtnList = [];	 % List of buttons used to change series.

% Data variables
co = [];		 % correltion map
ph = [];		 % phase map
amp = [];		 % amplitude map
map = [];                % arbitrary parameter map

% Fixing the color map range.
fixedCorCmapRange = [];
fixedAmpCmapRange = [];

tSeries=[];		 % The matrix holding time series data

% Analysis variables (changed with options under 'Edit' menu
tFilter=[11,2];		 % Size and s.d. of temporal filter (see EditTFilter.m)
sFilter=[5,1];           % Size and half-width of spatial filter (see EditSFilter.m)
pWindow=[0,360];	 % Phase window

loadRetWin = figure('MenuBar','none');

set(gcf,'Name',pwd);
disp('Initializing Callbacks')

% Init menu
ld = uimenu('Label','Init','separator','on');
uimenu(ld,'Label','Full Analysis','CallBack','[buttonid, inpstr]=mrFullAnalysisMenu(curSer);','Separator','on');

uimenu(ld,'Label','Enter Initial Parameters','CallBack','mrGetInitParams;','Separator','on');

% File menu
ld = uimenu('Label','File','separator','on');
uimenu(ld,'Label','Load Correlations','CallBack','[co, ph, amp, dc]=mrLoadCorAnal(viewPlane);RefreshScreen','Separator','on');
uimenu(ld,'Label','Save ROI','CallBack', ...
    'mrSaveROI(selpts,viewPlane,selpts_left,selpts_right);','Separator','on');
uimenu(ld,'Label','Load ROI','CallBack', '[selpts,selpts_inplane,selpts_left,selpts_right] = mrLoadROI(viewPlane);RefreshScreen;', ...
    'Separator','on');
uimenu(ld,'Label','Save Preferences','CallBack', ...
    'mrSavePrefs(curSer,slico,sliminlist,slimaxlist);',...
    'Separator','on');
uimenu(ld,'Label','Load Preferences','CallBack', ...
    '[curSer,sliminlist,slimaxlist,selpts]=mrLoadPrefs(slico,slimin,slimax,anatmap,numofanats);',...
    'Separator','on');

uimenu(ld,'Label','Quit','CallBack', ...
    'mrSavePrefs(curSer,slico,sliminlist,slimaxlist);delete(gcf);', ...
    'Separator','on');


% Edit menu
ld = uimenu('Label','Edit','separator','on');
uimenu(ld,'Label','Phase Window','CallBack',...
       'pWindow=mrEditPwindow(pWindow);','Separator','on');
uimenu(ld,'Label','Temporal Filter','CallBack',...
       'tFilter=mrEditTFilter(tFilter);','Separator','on');
uimenu(ld,'Label','Spatial Filter','CallBack',...
       'sFilter=mrEditSFilter(sFilter);','Separator','on');

% View menu
ld = uimenu('Label','View','Separator','on');

uimenu(ld,'Label','Correlation Map','CallBack', ...
    'curDisplayName = mrSetDisplayName(2);RefreshScreen', ...
    'Separator','on');

uimenu(ld,'Label','Amplitude Map','CallBack', ...
    'curDisplayName = mrSetDisplayName(3);RefreshScreen', ...
     'Separator','on');

uimenu(ld,'Label','Phase Map','CallBack', ...
    'curDisplayName = mrSetDisplayName(4);RefreshScreen', ...
    'Separator','on');

uimenu(ld,'Label','Weighted Phase Map','CallBack', ...
    'curDisplayName = mrSetDisplayName(10),RefreshScreen',...
    'Separator','on');

uimenu(ld,'Label','Parameter Map','CallBack', ...
    'curDisplayName = mrSetDisplayName(9);RefreshScreen', ...
    'Separator','on');

uimenu(ld,'Label','Cropped Anatomy','CallBack', ...
    'curDisplayName = mrSetDisplayName(1);RefreshScreen', ...
    'Separator','on');

uimenu(ld,'Label','Full Size Anatomy','CallBack', ...
    '[anat, anatmap, curSize, curDisplayName] = mrViewAnatRet(oSize, numofanats, numofexps, a_header, anatmap,curSer); curImage=anat(anatmap(1),:);oldDisplayName = curDisplayName;' ...
    ,'Separator','on');
uimenu(ld,'Label','Screen Save','CallBack', ...
    '[curImage, curSize,curDisplayName] =  mrViewSSRet(sizeSS);oldDisplayName = curDisplayName;', ...
    'Separator','on');
ROI_menu=uimenu(ld,'Label','Hide ROI','CallBack', ...
    'ROI_menu = mrToggleViewROI(ROI_menu);RefreshScreen', ...
    'Separator','on');

% ROI Select menu
ld = uimenu('Label','ROI Select','separator','on');
uimenu(ld,'Label','Rect','CallBack', ...
    '[selpts,selptsOld] = mrSelRectRet(curSize,selpts, anatmap(curSer));ResetSelpts;RefreshScreen', ...
    'Separator','on');

uimenu(ld,'Label','Poly','CallBack', ...
    '[curImage, selpts,selptsOld] = mrSelPolyRet(curImage,curSize, selpts, anatmap(curSer));ResetSelpts;RefreshScreen', ...
    'Separator','on');
uimenu(ld,'Label','Points ','CallBack', ...
    '[curImage, selpts,selptsOld] = mrSelPointsRet(curImage,curSize, selpts, anatmap(curSer));ResetSelpts;RefreshScreen', ...
    'Separator','on');
uimenu(ld,'Label','Line','CallBack', ...
    '[curImage, selpts,selptsOld] = mrSelLineRet(curImage,curSize,selpts,anatmap(curSer));ResetSelpts;RefreshScreen', ...
    'Separator','on');

uimenu(ld,'Label','Restrict ROI','CallBack',...
       'restrictROI;RefreshScreen',...
       'Separator','on');

uimenu(ld,'Label','Undo Last','CallBack', ...
    '[selpts,selptsOld]=mrUndoLastSelection(selpts,selptsOld);RefreshScreen', 'Separator','on');

% ROI Plots menu
ld = uimenu('Label','ROI Plots','separator','on');

% Open a new figure window for the next plot or graph
% 
callBackcmd = ...
 sprintf('%sgraphWin=figure(%sWindowStyle%s,%smodal%s);figure(loadRetWin)%s',...
   qt,qt,qt,qt,qt,qt);
uimenu(ld,'Label','New Plot Window','Separator','on','CallBack', callBackcmd);

tempid = uimenu(ld,'Label','Time Series','Separator','on');

%uimenu(tempid,'Label','This Slice','CallBack',...
%       '[tSergraphWin]=mrTsPlotRet(anatmap,curSer,tSeries,selpts,ncycles,junkimages,tFilter,viewPlane,graphWin,loadRetWin);', ...
%       'Separator','on');

uimenu(tempid,'Label','This Slice','CallBack',...
       '[graphWin,tSeries]=plotMeanTSeries(selpts,tSeries,curSer,tFilter,graphWin,loadRetWin,viewPlane);',...
       'Separator','on');

uimenu(tempid,'Label','All Slices','CallBack',...
       'graphWin=plotMeanTSeries(selpts,1:numofanats,curSer,tFilter,graphWin,loadRetWin,viewPlane);',...
       'Separator','on');

tempid = uimenu(ld,'Label','FFT','Separator','on');

%uimenu(tempid,'Label','This Slice','CallBack',...
%       '[tSeries,graphWin] = mrFftRoi(anatmap,curSer,tSeries,selpts,ncycles,junkimages,viewPlane,graphWin,loadRetWin);', ...
%       'Separator','on');
% Bill Press, 04/23/98
% Replace with following two uimenus:

uimenu(tempid,'Label','This Slice','CallBack',...
       '[graphWin,tSeries]=plotFftTSeries(selpts,tSeries,curSer,graphWin,loadRetWin,viewPlane);',...
       'Separator','on');

uimenu(tempid,'Label','All Slices','CallBack',...
       'graphWin=plotFftTSeries(selpts,1:numofanats,curSer,graphWin,loadRetWin,viewPlane);',...
       'Separator','on');


tempid = uimenu(ld,'Label','Vector Mean Plots','separator','on');

uimenu(tempid,'Label','Amplitude','CallBack',...
       'graphWin = mrPlotVectorMean(selpts,co,amp,ph,numofanats,numofexps,graphWin,loadRetWin,curSer);', ...
       'Separator','on');

uimenu(tempid,'Label','Polar Plot','CallBack',...
       'graphWin = mrPolarVectorMean(selpts,co,amp,ph,numofanats,numofexps,graphWin,loadRetWin,curSer);', ...
       'Separator','on');
   
uimenu(tempid,'Label','Mean Projected Amp','CallBack',...
       'graphWin = mrPlotMPA(selpts,co,amp,ph,numofanats,numofexps,graphWin,loadRetWin,curSer);', ...
       'Separator','on');

tempid = uimenu(ld,'Label','Mean Plots','separator','on');

uimenu(tempid,'Label','Correlation','CallBack',...
       'graphWin = mrPlotExpAmps(selpts,co,ph,pWindow,numofanats,numofexps,graphWin,loadRetWin,1);', ...
       'Separator','on');

uimenu(tempid,'Label','Amplitude','CallBack',...
       'graphWin = mrPlotExpAmps(selpts,amp,ph,pWindow,numofanats,numofexps,graphWin,loadRetWin,2);', ...
       'Separator','on');

uimenu(tempid,'Label','Parameter Map','CallBack',...
       'graphWin = mrPlotExpAmps(selpts,map,ph,pWindow,numofanats,numofexps,graphWin,loadRetWin,3);', ...
       'Separator','on');

   
tempid = uimenu(ld,'Label','ROI as Voxels','Separator','on');

uimenu(tempid,'Label','Cartesian','CallBack', ...
    '[co,ph,amp,graphWin]=mrPhaseVsCorr(curSer,anatmap(curSer),co,ph,amp,selpts,pWindow,0,viewPlane,graphWin,loadRetWin);', ...
    'Separator','on');

uimenu(tempid,'Label','Polar','CallBack', ...
    '[co,ph,amp,graphWin]=mrPhaseVsCorr(curSer,anatmap(curSer),co,ph,amp,selpts,pWindow,1,viewPlane,graphWin,loadRetWin);', ...
    'Separator','on');

uimenu(tempid,'Label','Surf Plot','CallBack', ...
    'graphWin = mrSurfROIRet(anatmap(curSer),tSeries,selpts,[],[],graphWin,loadRetWin);', ...
    'Separator','on');

tempid = uimenu(ld,'Label','ROI as dist','separator','on');

uimenu(tempid,'Label','Correlation','CallBack', ...
    '[origin,daty,dat_dist,graphWin]=mrROIdist(co,1,curSer,curSize,selpts,anatmap,graphWin,loadRetWin);', ...
    'Separator','on');

uimenu(tempid,'Label','Amplitude','CallBack', ...
    '[origin,daty,dat_dist,graphWin]=mrROIdist(amp,2,curSer,curSize,selpts,anatmap,graphWin,loadRetWin);', ...
    'Separator','on');

uimenu(tempid,'Label','Signed Amplitude','CallBack', ...
    '[origin,daty,dat_dist,graphWin]=mrROIdist((amp+sqrt(-1)*ph),4,curSer,curSize,selpts,anatmap,graphWin,loadRetWin);', ...
    'Separator','on');

uimenu(tempid,'Label','Phase','CallBack', ...
    '[origin,daty,dat_dist,graphWin]=mrROIdist(ph,3,curSer,curSize,selpts,anatmap,graphWin,loadRetWin);', ...
    'Separator','on');

tempid = uimenu(ld,'Label','ROI as line','separator','on');

uimenu(tempid,'Label','Correlation','CallBack',...
       'graphWin = mrPlotROIasLine(co,selpts,curSer,curSize,anatmap,1,graphWin,loadRetWin);', ...
       'Separator','on');

uimenu(tempid,'Label','Amplitude','CallBack',...
       'graphWin = mrPlotROIasLine(amp,selpts,curSer,curSize,anatmap,2,graphWin,loadRetWin);', ...
       'Separator','on');

uimenu(tempid,'Label','Phase','CallBack',...
       'graphWin = mrPlotROIasLine(ph,selpts,curSer,curSize,anatmap,3,graphWin,loadRetWin);', ...
       'Separator','on');

uimenu(tempid,'Label','Parameter Map','CallBack',...
       'graphWin = mrPlotROIasLine(map,selpts,curSer,curSize,anatmap,2,graphWin,loadRetWin);', ...
       'Separator','on');


% 
% Color Map menu. These are set up to work for phase data
% 
cmmenu = uimenu('Label','Color Map','Separator','on',...
    'ForegroundColor',[0.0 0.0 1.0]);

uimenu(cmmenu,'Label','Reset','CallBack', ...
    'phase_cmap = mrResetCmap(phase_cmap,curDisplayName,loadRetWin);', ...
    'Separator','on');

uimenu(cmmenu,'Label','Linearize','CallBack', ...
    'phase_cmap = mrLinearCmap(phase_cmap,curDisplayName,loadRetWin,2.0);', ...
    'Separator','on');
 
uimenu(cmmenu,'Label','DblWrap1','CallBack', ...
    'phase_cmap = mrDoubleWrap(phase_cmap,curDisplayName,loadRetWin,0);', ...
    'Separator','on');

uimenu(cmmenu,'Label','DblWrap2','CallBack', ...
    'phase_cmap = mrDoubleWrap(phase_cmap,curDisplayName,loadRetWin,1);', ...
    'Separator','on');

uimenu(cmmenu,'Label','Visual Areas','CallBack', ...
    'phase_cmap = mrvAreaCmap(phase_cmap,curDisplayName,loadRetWin);', ...
    'Separator','on');

uimenu(cmmenu,'Label','Shift','CallBack', ...
    'phase_cmap = mrShiftCmap(phase_cmap,curDisplayName);', ...
    'Separator','on');

uimenu(cmmenu,'Label','Rotate','CallBack', ...
    'phase_cmap = mrRotateCmap(phase_cmap,curDisplayName,loadRetWin);', ...
    'Separator','on');

uimenu(cmmenu,'Label','Set Cor Range','Separator','on',...
    'CallBack', [...
    	'fixedCorCmapRange = mrSetCorCmapRange(fixedCorCmapRange);', ...
	'RefreshScreen;']);

% 3D Menu
%
noDataVal = -99;
threeD_menu = uimenu('Label','3D','Separator','on');

select_menu = uimenu(threeD_menu,'Label','Create 3D data file',...
	'Separator','on');

uimenu(select_menu,'Label','Amplitude','Separator','on',...
	'Callback',['coThresh = get(slico,''Value'');',...
		'scanNum = getScanNum(anatBtnList);',...
		'mrValues2RGB(''amp'',scanNum,pWindow,coThresh,noDataVal);']);

uimenu(select_menu,'Label','Phase','Separator','on',...
	'Callback',['coThresh = get(slico,''Value'');',...
		'scanNum = getScanNum(anatBtnList);',...
		'mrValues2RGB(''ph'',scanNum,pWindow,coThresh,noDataVal);']);

uimenu(select_menu,'Label','Correlation','Separator','on',...
	'Callback',['coThresh = get(slico,''Value'');',...
		'scanNum = getScanNum(expBtnList);',...
		'mrValues2RGB(''co'',scanNum,pWindow,coThresh,noDataVal);']);

uimenu(select_menu,'Label','DC','Separator','on',...
	'Callback',['coThresh = get(slico,''Value'');',...
		'scanNum = getScanNum(anatBtnList);',...
		'mrValues2RGB(''dc'',scanNum,pWindow,coThresh,noDataVal);']);

% Special menu
%
ld = uimenu('Label','Special','separator','on');
uimenu(ld,'Label','Functional Movie','CallBack', ...
    'mrMakeMovie(tSeries,anat(anatmap(curSer),:),curSize,ncycles,junkimages);', ...
    'Separator','on');


% Visual Field Sign map, like Sereno
uimenu(ld,'Label','Visual Field Sign Map','CallBack', ...
    '[co,ph,amp,map] = mrFieldMap(co,ph,amp,map,curSer,curSize,viewPlane);curDisplayName = mrSetDisplayName(9);RefreshScreen;', ...
    'Separator','on');

% Inplane Indicator Map
uimenu(ld,'Label','Inplane Indicator Map','CallBack', ...
    '[map,cmap] = mrMakeInplaneMap(curSer,viewPlane);curDisplayName = mrSetDisplayName(9);RefreshScreen;colormap(cmap)', ...
    'Separator','on');


% Image management
%
immenu = uimenu(ld,'Label','Image Management','Separator','on');

uimenu(immenu,'Label','New subImage', ...
    'CallBack', '[subIm subSize]= mrExtractSubIm(curImage,curSize);',...
    'Separator','on'); 

uimenu(immenu,'Label','TiffSave', ...
    'CallBack', 'mrTiffImage(curImage,curSize);', ...
    'Separator','on'); 


comenu = uimenu(ld,'Label','Correlation','Separator','on');

uimenu(comenu,'Label','Connectedness','CallBack', ...
    'curDisplayName = mrSetDisplayName(5);RefreshScreen', ...
    'Separator','on');

uimenu(comenu,'Label','Median','CallBack', ...
    'curDisplayName = mrSetDisplayName(6);RefreshScreen', ...
    'Separator','on');

phmenu = uimenu(ld,'Label','Phase','Separator','on');

uimenu(phmenu,'Label','Connectedness','CallBack', ...
    'curDisplayName = mrSetDisplayName(7);RefreshScreen', ...
    'Separator','on');

uimenu(phmenu,'Label','Median','CallBack', ...
    'curDisplayName = mrSetDisplayName(8);RefreshScreen', ...
    'Separator','on');

uimenu(ld,'Label','Project Correlations','CallBack', ...
    'mrProjectCorAnal', ...
    'Separator','on');

uimenu(ld,'Label','Toggle Axis', ...
    'CallBack', 'axisflag=~axisflag;RefreshScreen', ...
    'Separator','on');

uimenu(ld,'Label','Quiver Plot','CallBack', ...
    'mrQuiver(curSer, co, ph, curSize);', ...
    'Separator','on');

uimenu(ld,'Label','Full Analysis (w/ I files)','CallBack', ...
    '[buttonid, inpstr]=mrFullAnalIfileMenu(curSer);'...
    ,'Separator','on');

uimenu(ld,'Label','mrAlign','CallBack', 'mrAlign','Separator','on');
 
uimenu(ld,'Label','Check for Shift','CallBack', ...
      'checkForShift(dr)','Separator','on');

%Sliders
% correlation threshold slider - 
% Inclusion of a 10th argument is a flag that the slico bar moved
% 
slico = uicontrol('Style','slider','String','Thresh','Units',...
		'normalized','Position',[.9,.75,.1,.05],'Callback','RefreshScreen');

% slimax slider
slimax = uicontrol('Style','slider','String','Max','Units',...
		'normalized','Position',[.9,.5750,.1,.05],'Callback',...
		'RefreshScreen');

% slimin slider
slimin = uicontrol('Style','slider','String','Min','Units',...
		'normalized','Position',[.9,.4,.1,.05],'Callback',...
		'RefreshScreen');

% Buttons
% 'Load tSeries' Button
tSerButton = uicontrol('Style','pushbutton','String','Load tSeries','Units','normalized',...
	'Position',[0,0,.3,.05],'Callback',...
	'tSeries=mrLoadTSeries(curSer,viewPlane);','FontSize',12);

% 'Clear ROI' Button (slice)
clearButton = uicontrol('style','pushbutton','string','Clear ROI in slice','units','normalized',...
	'Position',[.35,0,.3,.05],'CallBack',...
	'[selpts] = mrClearROI(selpts,anatmap(curSer),anatmap(curSer));ResetSelpts;RefreshScreen','FontSize',12);

% 'Clear ROI' Button (all)
clearButton = uicontrol('style','pushbutton','string','Clear ROI all slices','units','normalized',...
	'Position',[.70,0,.3,.05],'CallBack',...
	'[selpts] =  mrClearROI(selpts,1:numofanats,anatmap(curSer));ResetSelpts;selpts_left = [];selpts_right = [];selpts_inplane = [];RefreshScreen','FontSize',12);

% Inplane/Left/Right flattened representation buttons

inplaneButton = uicontrol('style','pushbutton','string','Inplanes','units','normalized',...
	'Position',[.9,.25,.1,.05],'CallBack',...
	'mrSwitch2Inplane');

leftButton =  uicontrol('style','pushbutton','string','L','units','normalized',...
	'Position',[.9,.2,.05,.05],'CallBack',...
	'Switch2Plane = 1; mrSwitch2Flat;','FontSize',12);
rightButton =  uicontrol('style','pushbutton','string','R','units','normalized',...
	'Position',[.95,.2,.05,.05],'CallBack',...
	'Switch2Plane = 2; mrSwitch2Flat;','FontSize',12);

blurButton = uicontrol('style','pushbutton','string','TBlurZ','units','normalized',...
	'Position',[.9,.15,.1,.05],'CallBack',...
	'[co,ph,amp,map] = mrBlurExp(co,ph,amp,map,curSer,curSize,sFilter,anat(anatmap(curSer),:),slico);RefreshScreen;');
    
blurButton = uicontrol('style','pushbutton','string','TBlurPh','units','normalized',...
	'Position',[.9,.1,.1,.05],'CallBack',...
	'[co,ph,amp,map] = mrBlurPh(co,ph,amp,map,curSer,curSize,sFilter,anat(anatmap(curSer),:),slico);RefreshScreen;');

if check4File('ExpParams')   % file exists, so load it in
	load ExpParams
else				 	% Otherwise create that file
	disp (['ExpParams.mat not found.  Please enter experimental values.']);
	mrGetInitParams;
end

% load in anat if the file exists
% 
disp('Checking anat file')
curDir = cd;
if check4File('anat') 
  fprintf('Loading anat.mat.\n');
  load anat;
else
  fprintf('Loading anat.mat not found in %s\n',curDir);
  fprintf('Creating anat.mat from raw anatomy images');
  [anat, anatmap, curSize, curDisplayName] = ...
      mrLoadAnatRet(curSize, numofanats, numofexps, a_header);
  mrSaveAnatRet(anat, anatmap, oSize, curSize, curCrop)
end

%load in Preference file, or create one if it doesn't exist.
% 
fprintf('Reading mrLoadRet Preferences file.\n')

[curSer,sliminlist,slimaxlist,selpts]= ...
    mrLoadPrefs(slico,slimin,slimax,anatmap,numofanats);

inplane_curSer = curSer; 

[anatBtnList, expBtnList] = mrCreateExpBtns(anatmap);

temp=cumsum(anatmap==anatmap(curSer));
curExp=temp(curSer);

[curSer, tSeries,sliminlist,slimaxlist] = ...
	mrNewExpBtn(anatBtnList,expBtnList,1,anatmap(curSer),anatmap,sliminlist,slimaxlist);


plot(0,0)
if tFilter(1)>imagesperexp
  tFilter = [1,1];
end

RefreshScreen

fprintf('Done loading mrLoadRet-1.0\n');


