function mrSavePrefs(curSer,slico,sliminlist,slimaxlist);
%mrSavePrefs
%
% 	mrSavePrefs(curSer,slico,sliminlist,slimaxlist);
% 
%Saves current state of mrLoadRet into file 'mrLoadRetPrefs.mat'
%in the current directory.

%1/20/96	gmb	Wrote the two lines of code. 
%1/24/97        gmb     No longer saves selpts

global axisflag

cothresh=get(slico,'value');
% 6/30/97 Lea updated to 5.0
save mrLoadRetPrefs curSer cothresh sliminlist slimaxlist axisflag -v4
