function phase_cmap = mrShiftCmap(phase_cmap,curDisplayName)
%phase_cmap = mrShiftCmap(phase_cmap,curDisplayName)
%
%Allows the user to re-define the color map for plotting phase
%data.  The user is instructed to click the left mouse twice,
%once for the lower and once for the upper limits.  Clicking
%the right mouse resets the colormap to the default (hsv(128))
%
%The lower limit can be greater than the upper limit.  The color
%map simply wraps around.
%9/18/96  gmb  Wrote it to go under the 'Special' menu.


%check to see if phases are on display
if ~(strcmp(curDisplayName,'phase') | ...
      strcmp(curDisplayName,'conphase') | ...
      strcmp(curDisplayName,'medphase'))
  disp(' Must be displaying phase data to use this function');
  return
end

%reset the colormap
phase_cmap = [gray(128);hsv(128)];
colormap(phase_cmap);

main = get(gcf,'CurrentAxes');

%Find the handle of the colorbar (if it exists);
cbar = [];
a=get(gcf,'Children');
for i=1:length(a)
  type = get(a(i),'Type');
  if (strcmp(type,'axes'))
    pos = get(a(i),'Position');
    if pos(2)==0.85
        cbar = a(i);
    end
  end
end

disp('Click the left mouse on the color bar twice:');
disp('Once for the lower limit, once for the upper limit.');
disp('Click the right button to reset the color map.');


set(gcf,'CurrentAxes',cbar);
[x,y,button]=ginput(2);
x(x<0)=zeros(size(find(x<0)));
x(x>360) = 360*ones(size(find(x>360)));

% 7/10/97 Lea updated to 5.0
if prod(button==1)
  if (x(2)>x(1))
    templen = round(128*(360/(x(2)-x(1))));
    tempcmap = hsv(templen);
    
    cmap = tempcmap(round(templen*x(1)/360)+1:round(templen*x(1)/360)+128,:);
  else
    templen = round(128*(360/(360-x(1)+x(2))));
    tempcmap = hsv(templen);
    cmap = [tempcmap(round(templen*x(1)/360):templen,:); ...
	    tempcmap(1:round(templen*x(2)/360),:)];
  end
  phase_cmap = [gray(128);cmap];
end

%Set the new color map
colormap(phase_cmap);
set(gcf,'CurrentAxes',main);





