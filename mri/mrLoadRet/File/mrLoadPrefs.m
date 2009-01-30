function [curSer,sliminlist,slimaxlist,selpts]=mrLoadPrefs(slico,slimin,slimax,anatmap,numofanats);
%mrLoadPrefs
%
%	[curSer,sliminlist,slimaxlist,selpts]=mrLoadPrefs(slico,slimin,slimax,numofanats);
%
%Loads in the file 'mrLoadRetPrefs.mat', if it exists.
%If the file does not exist, default values are created and saved.
global axisflag

if check4File('mrLoadRetPrefs')   % file exists, so load it in
	load mrLoadRetPrefs
        % 06/20/97 Lea Li -- updated to 5.0
	% The user might not have chosen some selpts yet
	% and matlab5 gripes when a returned argument is 
	% not being assigned
	if (~exist('selpts') == 1)
	   selpts = [];
	end
else
	sliminlist=0.01*ones(1,numofanats);
	slimaxlist=0.45*ones(1,numofanats);
	cothresh=0.5;
	curSer=1;
	selpts=[];
	disp(['file "mrLoadRetPrefs.mat" not found.  Creating Preference file with default values']);
	mrSavePrefs(curSer,slico,sliminlist,slimaxlist);
end

set (slico, 'value', .5)        % so mrThreshCorCol doesn't paint the screen green
set (slimin, 'value', .01)      % so opening picture looks good
set (slimax, 'value', .45)      % so opening picture looks good

set(slico,'value',cothresh);
set(slimin,'value',sliminlist(anatmap(curSer)));
set(slimax,'value',slimaxlist(anatmap(curSer)));








