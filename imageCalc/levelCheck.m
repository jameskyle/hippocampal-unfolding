function result = levelCheck(value_a_range)
% levelCheck(value_a_range)
%	LevelCheck(value_and_range) checks to see that the value and
%	range pairs are reasonable and if not tries to come up with
%	the best alternative.
%
%	If the size of the input has two or more rows and exactly
%	  two cols then the values are checked to insure that the
%	  first and last elements are 0 and 1 respectively.
%	If only one number was given (ie size = [1 1]) then a
%	  matrix is generated using LevelMake.
%	If there is only one row or one col then it is assumed to
%	  be a list of values and a matrix is generated.  A message is
%	  given and the generated matrix is displayed.
%	Otherwise an error is given and the program aborts.

% if only one number was given the generate a level matrix of given size.
if ((size(value_a_range, 1) == 1) & (size(value_a_range,2) == 1) &...
		 (value_a_range >= 2))
	value_a_range = levelMake(value_a_range);
% if only a column vector or a row vector then assume these are the values
%  and generate a matching set of ranges using least distance between
%  each value to determine the range.
elseif ((size(value_a_range,2) == 1 & (size(value_a_range,1) >= 1)) |...
		(size(value_a_range,1) == 1 & (size(value_a_range,2) >= 1)))
	% make a column vector of the appropriate size
	len = max(size(value_a_range));
	values = zeros(len,1);
	values(:) = sort(value_a_range(:));
	% make a empty vector for the ranges.
	ranges = zeros(len,1);
	ranges(1) = (values(1) + values(2)) / 2;
	the_tot = ranges(1);
	for i=2:len-1
		ranges(i) = ((values(i) + values(i+1)) / 2) - the_tot;
		the_tot = the_tot + ranges(i);
	end
	ranges(len) = 1 - sum(ranges);
	disp('generating new value_a_range matrix');
	disp([values ranges]);
	value_a_range = [values ranges];
elseif size(value_a_range,2) ~= 2
	error('Should have 2 columns, one of ranges and one of values');
elseif size(value_a_range,1) < 2
	error('The level matrix must have at least 2 values');
end

% if the value_a_range is not good then end.
if value_a_range(1,1) ~= 0
	error('Should have a 0 intensity for the first displayable value');
elseif value_a_range(size(value_a_range,1),1) ~= 1
	error('Should have a 1 intensity for the first displayable value');
elseif sum(value_a_range(:,2)) < 0.999
	error('The sum of all ranges should be 1');
end

result = value_a_range;
