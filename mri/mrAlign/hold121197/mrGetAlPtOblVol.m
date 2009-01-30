function [inpts,volpts] = mrGetAlPtOblVol(inpts,volpts,retwin,volwin,Zinp,obPts,obSize);
%
% mrGetAlignPoint
%
%     [inpts,volpts] = mrGetAlPtOblVol(inpts, volpts, retwin, volwin, Zinp, obSize);
%
%	Gets a point from the inplane and from the sagittal antomies.
%	Needs the z coordinates of inplane passed in.

npoints = size(volpts,1)+1;
figure(retwin);
tmp = ginput(1);
tmp(3) = Zinp;
inpts(npoints,:) = tmp;
figure(volwin);
tmp = ginput(1);
obcoord = round(tmp(2) +round(tmp(1)-1)*obSize(1));
volpts(npoints,:) = obPts(obcoord,:);

