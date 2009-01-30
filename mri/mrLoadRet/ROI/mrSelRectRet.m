function [selpts,originalSelpts] = mrSelRectRet (curSize, originalSelpts, curAnat);
% mrSelRecteRet (curImage,curSize,selpts,curAnat)
%
%	Returns a series of selected points which correspond
% to entries in the curImage matrix.  
%  Variable Declations

originalSize=size(originalSelpts,2);
[crop cropSize] = mrCrop;
cmin=min(crop);
cmax=max(crop);

locs = zeros(curSize);
locs(cmin(2):cmax(2),cmin(1):cmax(1))=ones(abs(cropSize));
locs=reshape(locs,1,prod(curSize));
locs=find(locs ~= 0);
locs=[locs;curAnat*ones(1,length(locs))];
selpts  = mrMergeSelpts(originalSelpts,locs);

finalSize=size(selpts,2);

disp([int2str(cropSize(1)),' by ',int2str(cropSize(2)),' pixel region selected, ',int2str(finalSize-originalSize),' pixels added.']);



%curImage = mrViewROIRet(curImage,curSize,selpts,curAnat);





