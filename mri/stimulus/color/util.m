(sFactor*(lms2rgb*-directionLMS) + lms2rgb*meanLMS)
(sFactor*(-deltaRGB) + meanRGB)
% This is how to plot the range of L,M values
% that we can create with this RGB monitor
%
redAlone = rgb2lms([1 2],1)';
greenAlone = rgb2lms([1 2],2)';
r  = [0 0;
      redAlone;
      redAlone + greenAlone;
      greenAlone;
      0 0];
r = r / mmax(r);
plot(r(:,1),r(:,2),'-')  
axis equal
axis square
plot(cones(:,1),cones(:,2))
hold on

rgb2lms
redAlone
greenAlone
rgb2lms
displayP = measured;
