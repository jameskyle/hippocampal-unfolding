function [curImage, selpts,originalSelpts] = mrSelPolyRet (curImage,curSize,originalSelpts, curAnat);
% mrSelPolyRet (curImage,curSize)
%
% Returns a series of selected points which correspond
% to entries in the curImage matrix.  

originalSize=size(originalSelpts,2);

region=markPoly(curSize);
pts=find(region>0)';
disp([int2str(length(pts)),' Points selected.']);


selpts =  mrMergeSelpts(originalSelpts,[pts;curAnat*ones(1,length(pts))]);

finalSize=size(selpts,2);
disp([int2str(finalSize-originalSize),' pixels added.']);




