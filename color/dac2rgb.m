function RGB = dac2rgb(DAC, gammaTable, grayLevels)

%%%%%%%%%%%%%%%
%%  dac2rgb  %%
%%%%%%%%%%%%%%%
%
% RGB = dac2rgb(DAC, gammaTable, grayLevels)
%
% This routine converts DAC (framebuffer) values into linear rgb values.
%
% DAC contains the frame buffer values of the 3 color planes.  These
%     are stored as three matrices joined by the form 
%               [DAC_r DAC_g DAC_b].
%     Normally, DAC values range from [0 255].  But, we allow them to be
%     in the [0 1] range here because Matlab seems to think that's OK.
%
% RGB contains the linear intensities of the three guns.  These 
%     are also stored in the form of 
%                  [r g b].
%     These linear intensities should always be in the range [0 1],
%     where 1 is the maximum intensity of the display gun.
%
% [grayLevels]  The number of gray levels available in the DAC.
%              If not passed it is assumed to be the same as the 
%              size of the gammaTable.  This is the usual case.
%
% Xuemei Zhang
% Last Modified 3/11/96

% If you don't tell us how many gray-levels the device has,
% we will assume that it is properly defined by the gammaTable.
%
if nargin < 3
 grayLevels = size(gammaTable,1);
end
%
%
if ( max(max(DAC))<=1 )
  DAC = DAC * (grayLevels - 1);
end

% Because of the image format, the separate color planes have
% m rows and n/3 columns
%
[m,n] = size(DAC);
if (3*round(n/3)) ~= n
  error('The number of columns in DAC must be a multiple of 3')
end

DAC = reshape(DAC, m*n/3, 3);
   
RGB = [gammaTable( DAC(:,1)+1, 1 ) ...
       gammaTable( DAC(:,2)+1, 2 ) ...
       gammaTable( DAC(:,3)+1, 3 )];

RGB = reshape(RGB, m, n);



