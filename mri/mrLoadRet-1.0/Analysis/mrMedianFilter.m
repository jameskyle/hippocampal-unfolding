function filtim = mrMedianFilter(im, filtsize)
% filter the matrix im with a median filter of size filtsize
% NOTE: edges get set to zero
% When filtsize is even, medians rounded down and right, e.g.
% xx
% xy

% jmz 5/9/95

% Variable declarations
filtim = [];     % matrix to hold the filtered values

imsize = size(im);
filtim = zeros(imsize(1),imsize(2));

% NOTE: these extra reshapes are to cut down on sorts
back = floor(filtsize/2);
forward = ceil(filtsize/2)-1;
for x=back+1:imsize(1)-forward
  for y=back+1:imsize(2)-forward
    sub = reshape(im(x-back:x+forward,y-back:y+forward),1,filtsize*filtsize);
    filtim(x,y) = median(sub);
  end
end
