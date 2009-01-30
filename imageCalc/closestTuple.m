function result = closestTuple(tuples, matchtuples)
% closestTuple(tuples, matchtuples)
% 	Returns a set of tuples which are the least squared matches 
%	of tuples to those in matchtuples.  Tuples must be column 
%	vectors. 
%
% Rick Anthony
% 11/18/93

[tupleDim, tupleNum] = size(tuples);
[matchDim, matchNum] = size(matchtuples);

if (tupleDim ~= matchDim)
    error('incompatible vector spaces.'); 
end


result = zeros(size(tuples));

for i = 1:tupleNum,
    error = matchtuples - kron(tuples(:,i), ones(1,matchNum));

    if(tupleDim == 1)
        error = error .* error;
    else
        error = sum(error .* error);
    end

    [tempvalue, index] = min(error);
    result(:,i)  = matchtuples(:,index(1));
end
