function  img = makeCubeIfiles(baseFileName, imDim, imList)
% img = makeCubeIfiles(baseFileName, imDim, imList)
%
% Reads in reconstructed Pfile images and compiles
% them into an image cube.  
%
% see also makeMontageIfiles

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
img = zeros(r,c,nImages);
count = 0;
for ii = imList
  count = count+1;
  fileName = sprintf('%s.%03d', baseFileName, ii);
  tempImg = readMRImage(fileName, header, [r c], byteFlag);
  img(:,:,count) = tempImg;
end

return;






















































































































