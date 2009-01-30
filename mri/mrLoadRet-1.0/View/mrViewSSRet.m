% mrViewSS (sizeSS)
%
%	Displays the screen save data

function [curImage, curSize, curDisplayName] = mrViewSS (sizeSS)

% Variable Declarations
global dr;
ss = [];   % The image data from the screen save
list = []; % Ummm, beats me...

%num = input('SS number?');
num=1; %It's never anything but number one.
ss = mrRead([dr,'/anatomy/SS/I.00',num2str(num),'.ss'],sizeSS);
list = (ss > 1000);		% No idea what this is for
ss(list) = zeros(1,sum(list));
curSize = sizeSS;
curImage = ss;
mrColorBar(0,'off');
myShowImage(curImage,curSize);
curDisplayName = 'SS';






