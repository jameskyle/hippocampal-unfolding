function [spectra,Xd,Yd] = daylightSpectrum(colorTemp)
%
%  [spectra,Xd,Yd] = daylightSpectrum(colorTemp)
%
% Creates a daylight spectrum with a given correlated Black Body temperature.
% Uses three Daylight Basis spectra (daycie).
%
% Based on Judd & Wyszecki "Color in Business Science and Industry"
% p. 111-116 
% Note: 1) error in Eq 2.2 on page 111, should be:
%                     Yd = -3*Xd^2 + 2.87*Xd - 0.275;
%       2) error in eq2.6 p. 112, should be:
%    M2 = (0.03 - 31.44243*Xd + 30.0717*Yd) / (0.0241 + 0.2562*Xd - 0.7341*Yd);
%

if (nargin < 1)
    disp('[spectra,Xd,Yd] = daylightSpectrum(colorTemp)');
    return;
end;

if (colorTemp > 40) & (colorTemp < 250)
    Tc = colorTemp.*100;
elseif (colorTemp > 4000) & (colorTemp < 25000)
    Tc = colorTemp;
else
    disp('colorTemp must be in [40..250] or [4000..25000]');
    return;
end;

if (Tc <= 7000)
 Xd = -4.6070*(10^9/Tc^3) + 2.9678*(10^6/Tc^2) + 0.09911*(10^3/Tc) + 0.244063;
else
 Xd = -2.0064*(10^9/Tc^3) + 1.9018*(10^6/Tc^2) + 0.24748*(10^3/Tc) + 0.237040;
end;


Yd = -3*Xd*Xd + 2.87*Xd - 0.275;

M1 = (-1.3515 - 1.7703*Xd + 5.9114*Yd) / ( 0.0241 + 0.2562*Xd - 0.7341*Yd);
M2 = (0.03 - 31.44243*Xd + 30.0717*Yd) / (0.0241 + 0.2562*Xd - 0.7341*Yd);

load '/usr/local/matlab/toolbox/stanford/color/data/daycie'

spectra = daycie(:,1) + M1.* daycie(:,2) + M2.* daycie(:,3);
