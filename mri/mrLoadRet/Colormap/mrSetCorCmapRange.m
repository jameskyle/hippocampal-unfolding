function [fixedCorCmapRange] = mrSetCorCmapRange(fixedCorCmapRange)
%
% [fixedCorCmapRange] = mrSetCorCmaRange()
% PURPOSE:  Set the range of the corrlation map for all displayed data.
% AUTHOR: Poirson
% DATE:   03.20.97
% HISTORY: We are doing the first amblyopia study today.  
% Brian is the subject. Amanda is in the driver's seat.

fprintf(' Set correlation range.\n');
if (length(fixedCorCmapRange) == 2)
	fprintf(' Current [low,hi]: %2.2f %2.2f\n',...
		fixedCorCmapRange(1),fixedCorCmapRange(2));
elseif (length(fixedCorCmapRange) == 0)
	fprintf(' Currently range varies with data set\n');
end
   
fprintf(' -Enter two values to set range (e.g. [0.1 0.7])\n');
fprintf(' -Enter empty matrix for auto range (e.g. [])\n');
temp = input(' ');
if ( (length(temp) ~= 2) & (length(temp) ~= 0) )
	fprintf(' Invalid entry.  Setting unchanged.\n');
	fixedCorCmapRange = fixedCorCmapRange;
else
	fixedCorCmapRange = temp;
end

return






