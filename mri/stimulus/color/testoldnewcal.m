%
%
%
cd /home/brian/exp/mri/stimuli/calibration

load /usr/local/matlab/toolbox/stanford/color/data/sanyoLCD	% Relevant spd
load /home/brian/matlab/cap/ncones

oldrgb2lms = (ncones')*sanyoLCD; 	%  3x3 conversion matrix

oldlms2rgb = inv(oldrgb2lms);		%Columns contain cone-isolating lights 
oldmaxlstim = oldlms2rgb(:,1)/max(abs(oldlms2rgb(:,1)));
oldmaxmstim = oldlms2rgb(:,2)/max(abs(oldlms2rgb(:,2)));
oldmaxsstim = oldlms2rgb(:,3)/max(abs(oldlms2rgb(:,3)));

load /home/engel/matlab/color/calibration/sanyoLCD82595		% Relevant spd
newrgb2lms = (ncones')*sanyoLCD; 	%  3x3 conversion matrix
newlms2rgb = inv(newrgb2lms);		%Columns contain cone-isolating lights 
newmaxlstim = newlms2rgb(:,1)/max(abs(newlms2rgb(:,1))); 
newmaxmstim = newlms2rgb(:,2)/max(abs(newlms2rgb(:,2)));
newmaxsstim = newlms2rgb(:,3)/max(abs(newlms2rgb(:,3)));

oldlstim = newrgb2lms*oldmaxlstim; 
oldmstim = newrgb2lms*oldmaxmstim; 
oldlstim = oldlstim/max(abs(oldlstim(1:2)));
oldmstim = oldmstim/max(abs(oldmstim(1:2)));
figure(1);
plot([0 oldlstim(1)],[0 oldlstim(2)],'r-');
hold on
plot([0 oldmstim(1)],[0 oldmstim(2)],'g-')
hold off
axis equal

load /home/brian/matlab/cap/XYZ

w = [1 1 1]';
[xy] = chromaticity(XYZ'*sanyoLCD*w)
r = [1 0 0]';
[xy] = chromaticity(XYZ'*sanyoLCD*r)
g = [0 1 0]';
[xy] = chromaticity(XYZ'*sanyoLCD*g)
b = [0 0 1]';
[xy] = chromaticity(XYZ'*sanyoLCD*b)



load /usr/local/matlab/toolbox/stanford/color/data/sanyoLCD	% Relevant spd
oldLCD = sanyoLCD;
load /home/engel/matlab/color/calibration/sanyoLCD82595		% Relevant spd
newLCD = sanyoLCD;

rat = oldLCD./newLCD;

figure(1); hold off
plot(rat);
hold on
plot(oldLCD*300);
hold off
m = mean(rat')';
numsamps = length(m);
range = (30:numsamps)';
p = polyfit(range,m(range),2);
fit = polyval(p,range);
figure(1); hold off
plot(rat);
hold on
plot(range,fit,'w*');
hold off

fit = polyval(p,range);
modelLCD = zeros(size(oldLCD));
modelLCD(range,:) = oldLCD(range,:)./(fit*ones(1,3));

plot(modelLCD)
hold on
plot(newLCD)
hold off

w = [1 1 1]';
[xy] = chromaticity(XYZ'*modelLCD*w)
[xy] = chromaticity(XYZ'*oldLCD*w)
r = [1 0 0]';
[xy] = chromaticity(XYZ'*modelLCD*r)
g = [0 1 0]';
[xy] = chromaticity(XYZ'*modelLCD*g)
b = [0 0 1]';
[xy] = chromaticity(XYZ'*sanyoLCD*b)

plot(oldLCD./modelLCD);




