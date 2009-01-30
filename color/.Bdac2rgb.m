function RGB = dac2rgb(DAC, gamma)

%%%%%%%%%%%%%%%
%%  dac2rgb  %%
%%%%%%%%%%%%%%%
%
% RGB = dac2rgb(DAC, gamma)
%
% DAC contains the frame buffer values of the 3 color planes.  These
%     are stored as three matrices joined by the form 
%               [DAC_r DAC_g DAC_b].
%
% RGB contains the linear intensity of the three guns.  These 
%     are also st in the form of [r g b].
%
% Xuemei Zhang
% Last Modified 3/11/96

%
%
if ( max(max(DAC))<=1 )
  DAC = DAC * 255;
end

[m,n] = size(DAC);
DAC = reshape(DAC, m*n/3, 3);
   
RGB = [gamma( DAC(:,1)+1, 1 ) gamma( DAC(:,2)+1, 2 ) gamma( DAC(:,3)+1, 3 )];

RGB = reshape(RGB, m, n);



