function handle_list= mrViewROIRet(curSize,selpts, curAnat)
%handle_list= mrViewROIRet(curSize,selpts, curAnat)

curColor = 'b';
w=0.5;
if any(selpts)
  pts = selpts(1,selpts(2,:)==curAnat);

  % 7/03/97 Lea updated to 5.0
  if ~isempty(pts)
    a=mrVcoord(pts',curSize);
    x=a(:,1);y=a(:,2);
    hold on
    hnum=0;
    for i=1:length(pts);
      hnum=hnum+1;
      handle_list(hnum)=line([x(i)-w,x(i)-w,x(i)+w,x(i)+w,x(i)-w], ...
	  [y(i)-w,y(i)+w,y(i)+w,y(i)-w,y(i)-w], ...
	  'Color',curColor);  
    end
  end
end
hold off






