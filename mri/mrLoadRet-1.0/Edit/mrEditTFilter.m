function [tFilter]=mrEditTFilter(tFilter)
% [tFilter]=mrEditTFilter(tFilter)


disp('Temporal filter size (pixels): ');
temp = input (['Default is ',num2str(tFilter(1)),': ']);
if (size(temp)) 
	tFilter(1)=temp;
else
	tFilter(1)=7;
end
disp(' ');
disp('Temporal filter standard deviation (pixels): ');
temp = input (['Default is ',num2str(tFilter(2)),': ']);
if (size(temp)) 
	tFilter(2)=temp;
else
	tFilter(2)=4;
end
