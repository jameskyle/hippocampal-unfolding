function z = twist(A,p,doRows);
% March 25, 1997, Herman Gollwitzer
% hgollwit@mcs.drexel.edu
%	A 		- matrix whose rows or columns are to be rotated circularly
%	p 		- list of rotations for each row or column, depending on doRows
% 	doRows	- a boolean that indicates the nature of the circular rotation
%	if doRows
% 		Carry out a rearrangement of A that is a circular 
% 		left(positive)or right shift(negative) on each row according
%		as the element in p is positive or negative, respectively.
%	else
% 		Carry out a rearrangement of A that is a circular
% 		up(positive) or down shift(negative) on each column according 
%		as the element in p is positive or negative, respectively.
%	Convention: Rotate rows when doRows is not passed in.
%Usage
%»a =
%     1     4     7    10    13
%     2     5     8    11    14
%     3     6     9    12    15
%»twist(a,[-1 0 1])
%    13     1     4     7    10
%     2     5     8    11    14
%     6     9    12    15     3
%»twist(a,[1 0 0 0 -1],0)
%     2     4     7    10    15
%     3     5     8    11    13
%     1     6     9    12    14
% ***** No Error checking: see rotatelr and rotateud *****
%	A must be a matrix, p must have enough integer-valued elements.
if nargin < 3 %default is to rotate rows
	doRows = 1;
else
	doRows = logical(doRows(1));
end
[m,n] = size(A);
if doRows
	base = n;
	span = m;
	A = A';
else %do columns
	base = m;
	span = n;
end
p = p(:)';
p = rem(p,base); %rem keeps the sign of p
p = p + base*(p < 0); %modified for negative shifts
s = (1:base)';
ss = [s;s]; %double length register for index selection
%It is a big indexing job.
offset = base*(0:span-1); offset = offset(ones(base,1),:);
select = ss(s(:,ones(span,1))+p(ones(base,1),:));
z = reshape(A(select+offset),base,span);
if doRows
	z = z';
end
