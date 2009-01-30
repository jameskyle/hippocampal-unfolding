function img = insertCrossFix(img,fixcolor,fixsize,fixthick,fixpos);

% Function to insert a cross-shaped fixation point
%  HB, 1/22/96
%  HB, Updated 9/25/97 to place fixation point in arbitrary position
%
%  img = insertCrossFix(img,fixcolor,fixsize,fixthick)
%
%  img:  Original image which will be replaced
%  fixcolor:  Color table value for fixation mark
%  fixsize:  Vertical/Horizontal extent of fixation cross (in pixels)
%  fixthick:  Width of lines of fixation cross (in pixels)
%  [fixpos]:  Two integer vector specifying pixel coordinates for
%             center of fixation mark (default=center)

halfsize = round(fixsize/2);
halfthick = ceil(fixthick/2);

if nargin < 5
  nx = size(img,1);
  ny = size(img,2);
  xcent = ceil(nx/2);
  ycent = ceil(ny/2);
  img(xcent-halfsize:(xcent-halfsize+fixsize)-1,ycent-halfthick:(ycent-halfthick+fixthick)-1) = fixcolor*ones(fixsize,fixthick);
  img(xcent-halfthick:(xcent-halfthick+fixthick)-1,ycent-halfsize:(ycent-halfsize+fixsize)-1) = fixcolor*ones(fixthick,fixsize);
else
  img(fixpos(1)-halfsize:(fixpos(1)+halfsize)-1,fixpos(2)-halfthick:(fixpos(2)-halfthick+fixthick)-1) = fixcolor*ones(fixsize,fixthick);
  img(fixpos(1)-halfthick:(fixpos(1)-halfthick+fixthick)-1,fixpos(2)-halfsize:(fixpos(2)-halfsize+fixsize)-1) = fixcolor*ones(fixthick,fixsize);
end

return

figure(1)
clf
image(img)
axis image
axis off


