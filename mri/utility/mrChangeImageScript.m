% mrChangeImageScript.m
% script
%
% 07.10.98  SJC
%
% PURPOSE:	To make my life easier.  Every time I need to add an
%		input parameter to mrVolChangeImage, I just need to do
%		do it once here instead of going through all the
%		functions that call mrVolChangeImage and changing each
%		call to it.  Why didn't I think of this before?!?
%

imgStruct = mrChangeImage(volStruct,displayStruct,grayStruct,layer1Struct,selectedNode,displayData,cutNodes,mVoxelsStruct,h_fig2);
