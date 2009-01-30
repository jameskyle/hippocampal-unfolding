%
%	Make the Sanyo LCD calibration data that will be put in
%
%	SEE:  Engel, Boynton, Wandell
%
cd /usr/local/matlab/toolbox/stanford/color/data/sanyoLCD
%
%
%	This contains the intensities measured with the Minolta
%	meter in cd/m^2
%
load -ascii rgbGammaData.dat

%	These are the frame-buffer levels at which the measurments were
%	made.
fbLevels = floor(linspace(0,255,11))';

%	We convert the cd/m^2 measurements to relative intensities
%
redInt = rgbGammaData(:,1)/max(rgbGammaData(:,1));
greenInt = rgbGammaData(:,2)/max(rgbGammaData(:,2));
blueInt = rgbGammaData(:,3)/max(rgbGammaData(:,3));

save rgbGammaData fbLevels redInt greenInt blueInt

%
%

sanyoLCDGam = zeros(256,3);
sanyoLCDGam(:,1)=  interp1(fbLevels,redInt,0:255);
plot(0:255,sanyoGam(:,1),'-',fbLevels,redInt,'o')
sanyoLCDGam(:,2)=  interp1(fbLevels,greenInt,0:255);
plot(0:255,sanyoGam(:,2),'-',fbLevels,greenInt,'o')
sanyoLCDGam(:,3)=  interp1(fbLevels, blueInt,0:255);
plot(0:255,sanyoGam(:,3),'-',fbLevels,blueInt,'o')

sanyoLCDGamInv =  mkInvTable(sanyoLCDGam,1000);

%	Write out the gamma curves
cd ..
save sanyoLCDGam sanyoLCDGam sanyoLCDGamInv

%
%	Write out the spectral data on the Sanyo
%
wave = 370:730;
dataRange = 390:730;
sanyoLCD = zeros(length(wave),3);
intSpec100 = interp1(wavelength,spec100,390:730);
sanyoLCD( (dataRange(1) - wave(1)+1):length(wave), 1:3) = intSpec100(:,1:3);
wavelengths = wave;

save sanyoLCD wavelengths sanyoLCD

%plot(wave,sanyoLCD)
