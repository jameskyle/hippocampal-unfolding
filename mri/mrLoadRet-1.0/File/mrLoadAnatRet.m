function [anat, anatmap, curSize, curDisplayName] = mrLoadAnatRet(curSize, numAnat, numExp, header,anatmap)
%[anat, anatmap, curSize, curDisplayName] = mrLoadAnatRet(curSize, numAnat, numExp, header,anatmap)
%
%Loads in the raw (unclipped) anatomy, and displays it. 

%12/22/95	gmb	anatmap is set to default values at all times 	

% Variable Declarations
global dr

%set anatmap to default values
anatmap=ceil( (1:numExp)/(numExp/numAnat));	
[anat,curSize] = mrSeries([dr,'/anatomy/inplane'],[1:numAnat],curSize,[],header);

curDisplayName = 'anatomy';







