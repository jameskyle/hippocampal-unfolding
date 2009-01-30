%mrColorBar(x_axis,[hide_state],[x_labels])
%
%Draws or manipulates a horizontal colorbar at the top of 
%mrLoadRet's image.
%
%Inputs:
%            x_axis:     vector of x-label of the color bar
%            hide_state  'on' makes the bar visible (default)
%                        'off' makes the bar invisible
%            x_labels    colorbar x-axis labels

%9/6/96 gmb   Wrote it.  Note, MATLAB's 'colorbar' screws
%             up the control buttons, hence mrColorBar.

function mrColorBar(x_axis,hide_state,x_labels)

if nargin == 1
   hide_state = 'on';
end

cbar = [];
%Find the handle of the colorbar (if it exists);
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

main = gca;

%If there is no colorbar, make one.
% 
if isempty(cbar) 
  main_pos = get(main,'position');

  bottom = 0.7;
  %main_pos(2)=main_pos(2)-main_pos(4)+top;
  main_pos(2)=0.1;
  main_pos(4)=0.7;
  set(main,'position',main_pos);
  
  cbar_pos = [main_pos(1) 0.85 main_pos(3) 0.05];
  cbar=subplot('position',cbar_pos);
  
end

% Re-draw the colorbar and set the axes (if x_axis is valid)
% The colorbar always contains the entries of the current color
% map running from 129 to 256.
% 
if (length(x_axis)>1)
  set(gcf,'CurrentAxes',cbar);
  image(x_axis,[],129:256);
  set(gca,'Xtick',x_axis);
  set(gca,'YTick',[]);
  if exist('x_labels');
    set(gca,'XTickLabel',x_labels);
  end
end

% Hide or show the color bar
% 
set(cbar,'Visible',hide_state);
temp = get(cbar,'Children');
set(temp,'Visible',hide_state);

% Return the current axes to the main image
% 
set(gcf,'CurrentAxes',main);
