% Load in 4 different spectral measurements for each gun.

prefs = ['r' 'g' 'b']';
origRange = 390:2:730;
newRange = 370:730;
full = loadAsciiCol(prefs,'glhc828','lcd');
intfull = interpRGB(origRange,full,newRange);
figure(1); plot(intfull);

full2 = loadAsciiCol(prefs,'glhc828','lc2');
intfull2 = interpRGB(origRange,full2,newRange);
figure(1); hold on; plot(intfull2); hold off;
sanyoLCD = (intfull+intfull2)/2;
wavelengths = newRange;

save sanyoLCD82895 wavelengths sanyoLCD
