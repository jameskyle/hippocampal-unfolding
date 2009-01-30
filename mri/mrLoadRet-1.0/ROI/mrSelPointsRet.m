function [curImage, selpts,originalSelpts] = mrSelPointsRet(curImage,curSize,originalSelpts,curAnat)
%[curImage, selpts] = mrSelPointsRet (curImage,curSize,selpts,curAnat)

%  Variable Declations
originalSize=size(originalSelpts,2);

tmp = mrSelPoints2(curImage,curSize);
tmp = [tmp;(curAnat*ones(1,length(tmp)))];

selpts =  mrMergeSelpts(originalSelpts,tmp);

finalSize=size(selpts,2);
disp([int2str(finalSize-originalSize),' pixels added.']);

curImage = mrViewROIRet(curSize,selpts,curAnat);




