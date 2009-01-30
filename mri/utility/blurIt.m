function img = blurIt(img,nTimes,imgSize)
%img = blurIt(img,nTimes,[imgSize])

origSize = size(img);

if exist('imgSize')
  img = reshape(img,imgSize);
end

blurFilt = [1,4,6,4,1]'*[1,4,6,4,1];
blurFilt = blurFilt/sum(blurFilt(:));

for i=1:nTimes
  img = conv2(img,blurFilt,'same');
end

if exist('imgSize')
  reshape(img,origSize);
end
