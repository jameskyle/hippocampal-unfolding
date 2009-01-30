function [sFilter]=mrEditsFilter(sFilter)
% [sFilter]=mrEditsFilter(sFilter)

if nargin==0
  sFilter = [7,4];
end

disp('Spatial filter size (pixels): ');
temp = input (['Default is ',num2str(sFilter(1)),': ']);
if (size(temp)) 
	sFilter(1)=temp;
end
disp(' ');
disp('Spatial filter half-width (pixels): ');
temp = input (['Default is ',num2str(sFilter(2)),': ']);
if (size(temp)) 
	sFilter(2)=temp;
end
