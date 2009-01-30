% AUTHOR:  Morland, Baseler
% DATE:    9/21/97
% PURPOSE:  Script to shift functional images so they align with the
% anatomical inplanes.  NOTE:  This script should only be run if
% the Pfiles are gone forever.  Otherwise, it is better to shift
% the Pfiles and re-recon them.  Check
% /home/heidi/mri/notes/Pshift for details.
%

load ExpParams
% Load the files required to check for alignment and display them
% in figures (1) and (2)
%
load anat
figure(1);
image(reshape(anat(1,:),curSize))
colormap gray(600); grid on;

load tSeries1
figure(2);
imagesc(reshape(tSeries(1,:),curSize))
colormap gray; grid on;

% Enter the number of pixels you require the functional images to
% be shifted by -ve numbers are up or left +ve are down or right
%
vertshift=input('Type the vertical shift in pixels to be applied to the functional images.  Positive = DOWN: ');
horzshift=input('Type the horizontal shift in pixels to be applied to the functional images.  Positive = RIGHT: ');

for j=1:numofexps
  clear tSeries
  eval(['load tSeries',num2str(j)]);
  for i=1:imagesperexp
    img = reshape(tSeries(i,:),curSize);
    img2 = zeros(curSize);
    if vertshift > 0 & horzshift > 0
      img2(1+vertshift:curSize(1),1+horzshift:curSize(2))= ...
        img(1:curSize(1)-vertshift,1:curSize(2)-horzshift);
    elseif vertshift < 0 & horzshift < 0
      img2(1:curSize(1)+vertshift,1:curSize(2)+horzshift) = ...
        img(1-vertshift:curSize(1),1-horzshift:curSize(2));
    elseif vertshift < 0 & horzshift > 0
      img2(1:curSize(1)+vertshift,1+horzshift:curSize(2)) = ...
        img(1-vertshift:curSize(1),1:curSize(2)-horzshift);
    else % if vertshift > 0 & horzshift < 0
      img2(1+vertshift:curSize(1),1:curSize(2)+horzshift)= ...
        img(1:curSize(1)-vertshift,1-horzshift:curSize(2));
    end
    tSeries(i,:) = img2(:)';
  end
  savstr = ['save tSeries',num2str(j),' tSeries'];
  disp(savstr)
  eval(savstr);
end

load tSeries1
figure(3)
imagesc(reshape(tSeries(1,:),curSize))
colormap gray; grid on;

