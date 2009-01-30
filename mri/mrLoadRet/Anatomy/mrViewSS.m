% mrViewSS (sizeSS)
%
%	Displays the screen save data

function [curImage, curSize] = mrViewSS (sizeSS)

% Variable Declarations
global dr;
ss = [];   % The image data from the screen save
list = []; % Ummm, beats me...

num = input('SS number?');
ss = mrRead([dr,'/anatomy/SS/I.00',num2str(num),'.ss'],sizeSS);
list = (ss == 32768);		% No idea what this is for
ss(list) = zeros(1,sum(list));
curSize = sizeSS;
curImage = ss;
myShowImage(curImage,curSize);

