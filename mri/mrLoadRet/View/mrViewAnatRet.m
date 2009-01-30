function [anat, anatmap, curSize, curDisplayName] = mrViewAnatRet(curSize, numAnat, numExp, header,anatmap,curSer)
% [anat, anatmap, curSize, curDisplayName] = mrViewAnatRet(curSize, numAnat, numExp, header,anatmap,[curSer])

%Loads in the raw (unclipped) anatomies, and displays one of them.  
%Returns curImage, curSize, and curDisplayName in that order.

%12/22/95	gmb	Wrote it 
%6/11/96	gmb	Added curSer as optional input variable
global dr

[anat,anatmap,curSize,curDisplayName]=mrLoadAnatRet(curSize,numAnat,numExp,header,anatmap);
if nargin <6
	curAnat=1;
else
	curAnat=anatmap(curSer);
end
myShowImage(anat(curAnat,:),curSize);
mrColorBar(0,'off');

curDisplayName = 'FullAnat';





