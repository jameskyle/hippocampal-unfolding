% Load in 4 different spectral measurements for each gun.

cd /usr/local/matlab/toolbox/stanford/color/data/sanyoLCD/032696

prefs = ['r' 'g' 'b']';
origRange = 390:2:730;
newRange = 370:730;
full = loadAsciiCol(prefs,'032696','lcd');
intfull = interpRGB(origRange,full,newRange);
figure(1); plot(intfull);

full2 = loadAsciiCol(prefs,'0326962','lcd');
intfull2 = interpRGB(origRange,full2,newRange);
figure(1); hold on; plot(intfull2); hold off;
sanyoLCD = (intfull+intfull2)/2;
wavelengths = newRange;

save sanyoLCD032696 wavelengths sanyoLCD

newsanyoLCD = sanyoLCD;

load ../031296/sanyoLCD031296
figure(2)
plot(sanyoLCD)
hold on
plot(newsanyoLCD)
hold off
figure(3)
plot(newsanyoLCD./sanyoLCD)

load XYZ

res = XYZ'*newsanyoLCD;			% Columns are XYZ's or each gun
xy = chromaticity(res);

load ncones

oldrgb2lms = (ncones')*sanyoLCD; 	%  3x3 conversion matrix
newrgb2lms = (ncones')*newsanyoLCD; 	%  3x3 conversion matrix

(oldrgb2lms*[0 0 1]')./(newrgb2lms*[0 0 1]')
