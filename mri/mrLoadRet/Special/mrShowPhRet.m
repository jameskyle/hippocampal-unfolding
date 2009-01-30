% figure(1);
% subplot(1,1,1);
if(curSer == 1)
curImage = ph1;
else
curImage = ph2;
end
curSize = imSize;
curMin = 0;
curImage = curImage - min(curImage);
curMax = max(curImage);
selOff = zeros(2,1);
colormap([gray(128);hsv(128)]);
myShowImage(curImage,curSize,curMin,curMax);

