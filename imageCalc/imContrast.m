function imContrast()
%
%	imContrast() -- A callback routine for image contrast adjustment
%
%	The routine maps the original image data, which are stored in
%	UserData, into the Cdata location.  The mapping is determined
%	by specifying the range of values mapped into the lookup table.
%
%	The routine reads the values of two sliders in the figure
%	to determine the image values that should be mapped to zero
%	and to the max colormap value.
%
f = gcf;
figChild = get(f,'Children');
count = 0;
slider = [0 1];
for i=1:length(figChild)
 if strcmp(get(figChild(i),'type'),'uicontrol') == 1
  if strcmp(get(figChild(i),'style'),'slider') == 1
    if count == 0
      slider(1) = get(figChild(i),'Value');
      count = 1;
    elseif count == 1
      slider(2) = get(figChild(i),'Value');  
    end
  end
 end
end
slider = sort(slider);
minSlider = slider(1);maxSlider = slider(2);
if minSlider == maxSlider
  maxSlider = minSlider + 1
end

%
%	We map the current cdata so that the smallest new value
%	is equal to the value of minSlider, and the value of
%	the largest new value is equal to the value of maxSlider.
%	The range of slider values is set by the colormap range:
%		[-colormap size, 2 colormap size]
a = gca;
mapMax = size(colormap,1);
axisChild = get(a,'Children');
for i=1:length(axisChild)
 if strcmp(get(axisChild(i),'type'),'image') == 1
    cdata = get(axisChild(i),'cdata');
    if cdata == []
     error('No user data set for contrast scaling');
    end
    minCdata = min(min(cdata));
    maxCdata = max(max(cdata));
    MaxMin = maxCdata - minCdata;
    a = (maxSlider - minSlider) / (maxCdata - minCdata);
    b = (maxCdata*minSlider - minCdata*maxSlider) / (maxCdata - minCdata);
    e = ones(size(cdata));
    set(axisChild,'cdata',a*cdata + b*e);
    cdata = get(axisChild,'cdata');
 end
end


disp('slider')
[minSlider maxSlider]
disp('cdata')
[min(min(cdata)) max(max(cdata))]
