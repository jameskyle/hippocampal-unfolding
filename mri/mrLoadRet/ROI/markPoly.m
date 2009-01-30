function [inPoly] = markPoly(imSize);
%[inPoly] = markPoly(imSize);
%
%  Allows user to select a polygonal region in an image
%  imsize:  size of image [m,n]
%  inPoly:  binary image of selected polygonal region
%
%  Example:
%    figure(1)
%    image(32*ones(50,50));
%    colormap(gray);
%    poly_img=128*markPoly([50,50]);
%    image(64*poly_img);
%
%  AUTHOR:  ENGEL, BOYNTON

%Select polygon in flattened image
cornerPts = [];
hold on
disp('Left button selects vertices, right button quits');
while(1)
  [x y but] = ginput(1);
  if but == 1
    cornerPts = [cornerPts ; x y];
  elseif but == 3
    break   
  end
  plot(cornerPts(:,1),cornerPts(:,2),'kx', ...
       cornerPts(:,1),cornerPts(:,2),'k-');
end

%	Add last line segment
cornerPts(size(cornerPts,1)+1,:) = cornerPts(1,:);	
plot(cornerPts(:,1),cornerPts(:,2),'kx', ...
       cornerPts(:,1),cornerPts(:,2),'k-');
hold off

nPts = size(cornerPts,1);

% Set up for flood fill
bounds = zeros(imSize);
for i = 2:nPts
	segx = cornerPts([(i-1),i],1);
	segy = cornerPts([(i-1),i],2);
	bounds = bounds | markLine(imSize,segx,segy);
end

disp('Please select a point in the interior of the region');
startPt = ginput(1);
inPoly = bounds;
inPoly = mrFloodFill(inPoly,imSize,startPt);
%mrManifoldDistance(inPoly,imSize,1,[startPt,1]);
%gmb changed this.  Why did it bust?
%inPoly = reshape(inPoly,imSize(1),imSize(2));
%inPoly = (inPoly > 0);
%inPoly(startPt(2),startPt(1)) = 1;
