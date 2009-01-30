function DAC = rgb2dac(RGB, invGamma)

%%%%%%%%%%%%%%%%%%%
%%    rgb2dac    %%
%%%%%%%%%%%%%%%%%%%
%
% DAC = rgb2dac(RGB, invGamma)
%
% This routine converts linear rgb values into DAC (framebuffer) values.
%
% RGB contains the linear intensities of the three guns.  These 
%     are also stored in the form of 
%                  [r g b].
%     These linear intensities should always be in the range [0 1],
%     where 1 is the maximum intensity of the display gun.
%
% invGamma is the inverse lookup table for the gamma curve.
%
% DAC is returned as [DAC_r DAC_g DAC_b]. These are the frame buffer values.
%
% Xuemei Zhang
% Last Modified 3/11/96

% Because of the image format, the separate color planes have
% m rows and n/3 columns
%
[m,n] = size(RGB);

if (3*round(n/3)) ~= n
  error('The number of columns in RGB must be a multiple of 3')
end

RGB = reshape(RGB, m*n/3, 3);

RGB = round(RGB*(size(invGamma,1)-1)) + 1;
DAC = zeros(size(RGB));
DAC(:,1) = invGamma(RGB(:,1), 1);
DAC(:,2) = invGamma(RGB(:,2), 2);
DAC(:,3) = invGamma(RGB(:,3), 3);

DAC = reshape(DAC, m, n)/255;
