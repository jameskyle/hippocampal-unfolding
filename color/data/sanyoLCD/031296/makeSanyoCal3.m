% Load in 4 different spectral measurements for each gun.

cd /usr/local/matlab/toolbox/stanford/color/data/sanyoLCD/031296

prefs = ['r' 'g' 'b']';
origRange = 390:2:730;
newRange = 370:730;
full = loadAsciiCol(prefs,'san312','lcd');
intfull = interpRGB(origRange,full,newRange);
figure(1); plot(intfull);

full2 = loadAsciiCol(prefs,'san2312','lcd');
intfull2 = interpRGB(origRange,full2,newRange);
figure(1); hold on; plot(intfull2); hold off;
sanyoLCD = (intfull+intfull2)/2;
wavelengths = newRange;

save sanyoLCD031296 wavelengths sanyoLCD

load ../082895/sanyoLCD82895
figure(2)
plot(sanyoLCD)

load red031296.dat;  r =  mean(red031296')';
load grn031296.dat;  g =  mean(grn031296')';
load blu031296.dat;  b =  mean(blu031296')';

r(1) = 0; g(1) = 0; b(1) = 0;
r = r/max(r);
g = g/max(g);
b = b/max(b);

fbLevels = floor(linspace(0,255,9))';

sanyoLCDGam = zeros(256,3);
sanyoLCDGam(:,1)=  interp1(fbLevels,r,0:255);
sanyoLCDGam(:,2)=  interp1(fbLevels,g,0:255);
sanyoLCDGam(:,3)=  interp1(fbLevels, b,0:255);

figure(3);
plot(sanyoLCDGam);

sanyoLCDGamInv =  mkInvTable(sanyoLCDGam,1000);

save sanyoLCDGam031296 sanyoLCDGam sanyoLCDGamInv

load ../082695/sanyoLCDGam082695 

figure(4);
plot(sanyoLCDGam);
