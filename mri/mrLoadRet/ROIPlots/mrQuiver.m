function mrQuiver(curSer,co,ph,curSize);

%MRQUIVER
%	mrQuiver(curSer,co,ph,curSize)
%
%	Overlays QuiverPlot of correlations (co) and phase (ph)
%	of the current series (curSer).
%
%	gmb 4/5/95
%
%	See also QUIVER

if (prod(size(co))>1)	
  mrColorBar(0,'off');
  
  sco=co(curSer,:);
  sco=(sco-0.12);
  sco(find(sco<0))=zeros(size(find(sco<0)));
  dx=reshape(sco.*cos(ph(curSer,:)),curSize(1),curSize(2));
  dy=reshape(sco.*sin(ph(curSer,:)),curSize(1),curSize(2));
  %	dy=flipud(dy);
  hold on
  quiver(dx,dy,5);
  hold off
else
  disp(['Correlation data not available.']);
end
      
