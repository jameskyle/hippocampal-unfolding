cd /home/engel/matlab/color/calibration
% Load in 4 different spectral measurements for each gun.

prefs = ['r' 'g' 'b'];
origRange = 390:2:730;
newRange = 370:730;
basic = loadAsciiCol(prefs,'828s1','lcd');
intbasic = interpRGB(origRange,basic,newRange);
figure(1); plot(intbasic);

allbutglass = loadAsciiCol(prefs,'h828s1','lcd');
intabg = interpRGB(origRange,allbutglass,newRange);
figure(2); plot(intabg);

mirror = loadAsciiCol(prefs,'hm828s1','lcd');
intmir = interpRGB(origRange,mirror,newRange);
figure(2); plot(intmir);

glass = loadAsciiCol(prefs,'gl828','lcd');
intgl = interpRGB(origRange,glass,newRange);
figure(2); plot(intgl);

full = loadAsciiCol(prefs,'glhc828','lcd');
intfull = interpRGB(origRange,full,newRange);
figure(2); plot(intfull);

full2 = loadAsciiCol(prefs,'glhc828','lc2');
intfull2 = interpRGB(origRange,full2,newRange);
figure(2); plot(intfull2);

figure(1); plot(basic./allbutglass);
plot(basic./glass);
plot(full./basic); hold on; plot(basic*50+.6); hold off
plot(basic); hold on; plot(full*5); hold off

load /home/engel/matlab/color/calibration/sanyoLCD82595
figure(2); plot(intfull); hold on; plot(sanyoLCD); hold off
plot(intfull(:,2),sanyoLCD(:,2),'wx')
plot(intfull(:,2),intbasic(:,2),'wx')
load /home/brian/matlab/cap/XYZ

w = [1 1 1]';
[xy] = chromaticity(XYZ'*intbasic*w)
r = [1 0 0]';
[xy] = chromaticity(XYZ'*intbasic*r)
g = [0 1 0]';
[xy] = chromaticity(XYZ'*intbasic*g)
b = [0 0 1]';
[xy] = chromaticity(XYZ'*intbasic*b)

tmp1 = xyY2XYZ([.649 .331 496]');
tmp2 = xyY2XYZ([.312 .682 2600]');
tmp3 = xyY2XYZ([.139 .028 99]');
tmp4 = xyY2XYZ([.302 .368 3220]');

XYZw = XYZ'*intbasic*w
XYZr = XYZ'*intbasic*r
XYZg = XYZ'*intbasic*g
XYZb = XYZ'*intbasic*b

XYZr+XYZg+XYZb
XYZw
