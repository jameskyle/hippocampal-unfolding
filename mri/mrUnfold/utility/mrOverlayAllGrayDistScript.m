% mrOverlayLayer1DistScript.m
% script
%
% 07.10.98  SJC
%
% PURPOSE:	To make my life easier.  Every time I need to add an
%		input parameter to mrOverlayDist, I just need to do
%		do it once here instead of going through all the
%		functions that call mrVolChangeImage and changing each
%		call to it.  Why didn't I think of this before?!?
%
%		Calls mrOverlayDist with all the gray matter points as
%		an input parameter.
%		(mrOverlayAllGrayDistScript calls it with only layer 1
%		gray matter points as an input parameter).

[selectedNode, displayStruct.flags(3), imgStruct] = ...
	mrOverlayDist(volStruct,displayStruct,grayStruct,selectedNode,cutNodes,mVoxelsStruct,h_fig2);
