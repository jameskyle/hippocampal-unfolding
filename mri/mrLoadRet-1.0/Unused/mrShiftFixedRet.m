function [anat, curImage] = mrShiftFixedRet(anat, anatmap, numAnat, numExp, size, shif);
% mrShiftFixedRet.m
% function [anat, curImage] = mrShiftFixedRet(anat, anatmap, numAnat, numExp, size, shif);
% Shifts anatomies by amount specified in shif (x,y in pixels).
%

% Variable declarations
global dr

path = [];     % where to find a functional image
testfun = [];                    % functional image (number 1)
p1 = 0;				 % first point
p2 = 0;				 % second point
imap = [];			% map from anat to funs.

for i = (1:numExp)
imap(anatmap(i)) = i;
end

for i = (1:numAnat)
anat(i,:) = mrShiftImage(anat(i,:),size,shif);
disp('Shifting by:');
disp(shif);
end

curImage = anat(numAnat,:);
myShowImage(curImage,size);

