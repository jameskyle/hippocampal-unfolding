function DAC = rgb2dac(RGB, invGamma)
%%%%%%%%%%%%%%%%%%%
%%    rgb2dac    %%
%%%%%%%%%%%%%%%%%%%
%
% DAC = rgb2dac(RGB, invGamma)
%
% RGB must be between [0,1]. It should be in the form [R G B]. These
%    are actual intensities of light emitted from the phosphors.
%
% invGamma is the inverse lookup table for the gamma curve.
%
% DAC is returned as [DAC_r DAC_g DAC_b]. These are the frame buffer values.
%
% Xuemei Zhang
% Last Modified 3/11/96

[m,n] = size(RGB);
RGB = reshape(RGB, m*n/3, 3);

RGB = round(RGB*(size(invGamma,1)-1)) + 1;
DAC = zeros(size(RGB));
DAC(:,1) = invGamma(RGB(:,1), 1);
DAC(:,2) = invGamma(RGB(:,2), 2);
DAC(:,3) = invGamma(RGB(:,3), 3);

DAC = reshape(DAC, m, n)/255;
