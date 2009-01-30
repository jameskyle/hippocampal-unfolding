function mrSetColorBarAxis(x_axis);

%Find the handle of the colorbar
a=get(gcf,'Children')
for i=1:length(a)
  type = get(a(i),'Type');
  if (strcmp(type,'axes'))
    pos = get(a(i),'Position');
    if pos(4)==0.05
        cbar = a(i);
    end
  end
end

