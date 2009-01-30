% mrShiftAnatRet.m
% Presents both a functional image and the anatomy image
% User clicks a pair of corresponding points in both images (first fun, then anat)
% Functionized by Greg 10/18

function [anat, curImage, curSize, curMin, curMax] = mrShiftAnatRet(anat, anatmap, numAnat, numExp, size, header);

% Variable declarations
global dr slimin slimax

anatmin = get(slimin,'value');
anatmax = get(slimax,'value');

path = [];     % where to find a functional image
testfun = [];                    % functional image (number 1)
p1 = 0;				 % first point
p2 = 0;				 % second point
imap = [];			% map from anat to funs.

for i = (1:numExp)
imap(anatmap(i)) = i;
end

mrSetUp(2);
for i = (1:numAnat)
figure(1);
myShowImage(anat(i,:),size);
figure(2);
path = [dr,'/exp',num2str(imap(i)),'/I.010'];
testfun = mrRead(path,size,header);
myShowImage(testfun,size);
p1 = ginput(1);
figure(1);
p2 = ginput(1);
anat(i,:) = mrShiftImage(anat(i,:),size,round(p1-p2));
disp('Shifting by:');
disp(round(p1-p2));
end

curImage = anat(numAnat,:);
curSize = size;   % This may not be necessary in which case this fn shouldn't pass out curSize
myShowImage(curImage,curSize);

