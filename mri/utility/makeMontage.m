function  img = makeMontage(imgCube, [sliceList], [fileName])
%img = makeMontage(imgCube, [sliceList], [fileName])
%
% Compiles a montage image from the images in imgCube.  
% (imgCube is x by y by sliceNum)
% sliceList, if specified, determines which slices to extract.
% (it defaults to all slices if it's empty or omitted)
% The image is displayed and will be saved to the fileName
% as a jpeg, if fileName is specified.
%
% see also makeMontageIfiles

header = 0;
if strcmp(computer,'PCWIN')
	byteFlag = 'b';
else
   byteFlag = 'n';
end

if ~exist('sliceList', 'var')
   sliceList = [];
end
if isempty(sliceList)
   sliceList = [1:size(imgCube, 3)];
end

[r,c] = size(imgCube(:,:,1));

nImages = length(sliceList);
numAcross = min(4,nImages);
numDown = ceil(nImages/numAcross);
img = zeros(r*numDown,c*numAcross);
count = 0;
for ii = imList
  count = count+1;
  x = rem(count-1, numAcross)*c;
  y = floor((count-1)/ numAcross)*r;
  img(y+1:y+r,x+1:x+c) = imgCube(:,:,ii);
end

img2 = uint8(floor(img./max(img(:))*255));
figure;
colormap(repmat([0:1/255:1]',1,3));
image(img2);
axis image;
axis off;

if exist('fileName', 'var')
   imwrite(img2, [baseFileName '.jpg'], 'jpg', 'Quality', 100);
   disp(['Wrote montage to ' pwd '/' baseFileName '.jpg']);
end




















































































































