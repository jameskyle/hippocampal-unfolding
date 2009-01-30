function  img = makeMontageIfiles(baseFileName, imDim, imList)
% img = makeMontageIfiles(baseFileName, imDim, imList)
%
% Reads in reconstructed Pfile images and compiles
% them into an image montage.  
%
% see also makeCubeIfiles

header = 0;
if strcmp(computer,'PCWIN')
	byteFlag = 'b';
else
   byteFlag = 'n';
end

if length(imDim) == 1
   r = imDim;
   c = imDim;
else
   r = imDim(1);
   c = imDim(2);
end

nImages = length(imList);
numAcross = min(4,nImages);
numDown = ceil(nImages/numAcross);
img = zeros(r*numDown,c*numAcross);
count = 0;
for ii = imList
  count = count+1;
  fileName = sprintf('%s.%03d', baseFileName, ii);
  tempImg = readMRImage(fileName, header, [r c], byteFlag);
  x = rem(count-1, numAcross)*c;
  y = floor((count-1)/ numAcross)*r;
  img(y+1:y+r,x+1:x+c) = tempImg;
end

return;






















































































































