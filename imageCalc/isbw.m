function y = isbw(x)
%ISBW True for binary images.
%	ISBW(A) returns 1 if A is a binary image and 0 otherwise.
%	An binary image contains only the values 0 or 1.
%
%	See also ISIND, ISGRAY.

%	Clay M. Thompson 2-25-93
%	Copyright (c) 1993 by The MathWorks, Inc.
%	$Revision: 1.4 $  $Date: 1993/08/18 03:11:50 $

y = ~any(any(x~=0 & x~=1));
