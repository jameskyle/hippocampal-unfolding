% Load in 4 different spectral measurements for each gun.
load blu255v1.lcd
b = blu255v1(:,2);
load red255v1.lcd
r = red255v1(:,2);
load grn255v1.lcd
g = grn255v1(:,2);
tmp1 = [r g b];

load blu255v2.lcd
b = blu255v2(:,2);
load red255v2.lcd
r = red255v2(:,2);
load grn255v2.lcd
g = grn255v2(:,2);
tmp2 = [r g b];

load blu255v5.lcd
b = blu255v5(:,2);
load red255v5.lcd
r = red255v5(:,2);
load grn255v5.lcd
g = grn255v5(:,2);
tmp3 = [r g b];

load blu255v6.lcd
b = blu255v6(:,2);
load red255v6.lcd
r = red255v6(:,2);
load grn255v6.lcd
g = grn255v6(:,2);
tmp4 = [r g b];

spec100 = (tmp1+tmp2+tmp3+tmp4)/4;		% Average spec output
wavelength = grn255v6(:,1);			% Spectra meas. locs.
finalwave = 370:730;				% Goal: same range as ncones
dataRange = min(wavelength):max(wavelength);	% 1 nm steps
intSpec100 = interp1(wavelength,spec100,dataRange);  % Interpolate out
sanyoLCD = zeros(length(finalwave),3);		% Zero padding
sanyoLCD((dataRange(1) - finalwave(1)+1):length(finalwave), 1:3) = ...
				intSpec100(:,1:3);
wavelengths = finalwave;

save sanyoLCD82695 wavelengths sanyoLCD

load blu82695.dat;  b =  mean(blu82695')';
load grn82695.dat;   g = mean(grn82695')';
load red82695.dat;   r = mean(red82695')';
r(1) = 0; g(1) = 0; b(1) = 0;
r = r/max(r);
g = g/max(g);
b = b/max(b);
figure(1);
plot([r g b])

fbLevels = floor(linspace(0,255,9))';

sanyoLCDGam = zeros(256,3);
sanyoLCDGam(:,1)=  interp1(fbLevels,r,0:255);
sanyoLCDGam(:,2)=  interp1(fbLevels,g,0:255);
sanyoLCDGam(:,3)=  interp1(fbLevels, b,0:255);

figure(1);
plot(sanyoLCDGam);

sanyoLCDGamInv =  mkInvTable(sanyoLCDGam,1000);

save sanyoLCDGam082695 sanyoLCDGam sanyoLCDGamInv
