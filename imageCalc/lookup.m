function result = lookup(indexes, table)
% lookup(indexes, table)
%	Returns the value of the table at the specified index.  Indexes
%	and tables are arranged in row vectors.  Multiple sets of indexes
%	and tables may be passed as row vectors, but each row of indexes
%	must have a corresponding table.
%
% For exmaple,
%
%	indexes = [idx1; idx2; idx3];
%	table = [tab1; tab2; tab3];
%
% 	result = [tab1(idx1); tab2(idx2); tab3(idx3)];
%
% 	Also to accommidate any size table indexes must be in the 
%	range [0,1];
%
% Rick Anthony
% 11/19/93


[indexDim, indexNum] = size(indexes);
[tableDim, tableNum] = size(table);


result = zeros(size(indexes));

for i = 1:indexDim,
    result(i,:) = table(i, round((tableNum-1) * indexes(i,:) + 1));
end
